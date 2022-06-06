data"aws_ecs_cluster""ecs" {
  cluster_name ="${var.ecs_cluster_name}-cluster"

}

data"aws_alb""alb" {
  name ="${var.ecs_cluster_name}-load-balancer"
}

data"aws_lb_listener""listener" {
  load_balancer_arn = data.aws_alb.alb.arn
  port = var.tls_port
}

data"aws_subnet_ids""subnets" {
  vpc_id = data.aws_alb.alb.vpc_id
  tags = {
    Name = var.ecs_cluster_name
  }
}

data"aws_partition""current" {}

resource"random_id""snapshot_identifier" {
  keepers = {
    id = var.name
  }
  byte_length = 4
}

resource"aws_db_subnet_group""rds" {
  count = var.create_cluster && var.create_db_subnet_group ? 1 : 0
  name          ="${var.ecs_cluster_name}-rds-aurora-dsg"
  description   ="For Aurora cluster Environment : ${var.ecs_cluster_name}"
  subnet_ids    = data.aws_subnet_ids.subnets.ids 
  tags = {
    Name        ="${var.ecs_cluster_name}-rds-aurora-dsg"
    Environment = var.ecs_cluster_name
  }
}

resource"aws_kms_key""main" {
  description             = "${var.ecs_cluster_name}-rds-aurora-kms"
  deletion_window_in_days = 10
}

resource"aws_kms_alias""main" {
  name          = "alias/rdssql57-${var.ecs_cluster_name}"
  target_key_id = aws_kms_key.main.key_id
}

resource"aws_db_parameter_group""rds" {
  name        = "${var.ecs_cluster_name}-aurora-mysql57-pg"
  family      = "aurora-mysql5.7"
  description = "${var.ecs_cluster_name}-aurora-db-mysql57-parameter-group"
  tags = {
    Name        = "${var.ecs_cluster_name}-aurora-mysql57-pg"
    Environment = var.ecs_cluster_name
  }
}

resource"aws_rds_cluster_parameter_group""rds" {
  name        = "${var.ecs_cluster_name}-aurora-mysql57-cpg"
  family      = "aurora-mysql5.7"
  description = "${var.ecs_cluster_name}-aurora-mysql57-cluster-parameter-group"
  tags = {
    Name        = "${var.ecs_cluster_name}-aurora-mysql57-cpg"
    Environment = var.ecs_cluster_name
  }
}

resource"aws_rds_cluster""rds" {
  count = var.create_cluster ? 1 : 0
  global_cluster_identifier      = var.global_cluster_identifier
  enable_global_write_forwarding = var.enable_global_write_forwarding
  cluster_identifier             = var.name
  replication_source_identifier  = var.replication_source_identifier
  source_region                  = var.source_region
  engine                              = var.engine
  engine_mode                         = var.engine_mode
  engine_version                      = var.engine_version 
  allow_major_version_upgrade         = var.allow_major_version_upgrade
  enable_http_endpoint                = var.enable_http_endpoint
  kms_key_id                          = aws_kms_key.main.arn
  database_name                       = var.is_primary_cluster ? var.database_name : null
  master_username                     = var.is_primary_cluster ? var.master_username : null
  master_password                     = var.is_primary_cluster ? var.master_password : null
  final_snapshot_identifier           = "${var.final_snapshot_identifier_prefix}-${var.ecs_cluster_name}-${element(concat(random_id.snapshot_identifier.*.hex, [""]), 0)}"
  skip_final_snapshot                 = var.skip_final_snapshot
  deletion_protection                 = var.deletion_protection
  backup_retention_period             = var.backup_retention_period
  preferred_backup_window             = var.preferred_backup_window
  preferred_maintenance_window        = var.preferred_maintenance_window
  port                                = var.port
  db_subnet_group_name                = "${var.ecs_cluster_name}-rds-aurora-dsg" 
  vpc_security_group_ids              = compact(concat(aws_security_group.rds.*.id, var.vpc_security_group_ids))
  snapshot_identifier                 = var.snapshot_identifier
  storage_encrypted                   = var.storage_encrypted
  apply_immediately                   = var.apply_immediately
  db_cluster_parameter_group_name     = "${var.ecs_cluster_name}-aurora-mysql57-cpg" 
  db_instance_parameter_group_name    = var.allow_major_version_upgrade ? var.db_cluster_db_instance_parameter_group_name : null
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  backtrack_window                    = (var.engine == "aurora-mysql" || var.engine == "aurora") && var.engine_mode != "serverless" ? var.backtrack_window : 0 
  copy_tags_to_snapshot               = var.copy_tags_to_snapshot
  enabled_cloudwatch_logs_exports     = var.enabled_cloudwatch_logs_exports
  
  timeouts {
    create = lookup(var.cluster_timeouts,"create", null)
    update = lookup(var.cluster_timeouts,"update", null)
    delete = lookup(var.cluster_timeouts,"delete", null)
  }


  dynamic"restore_to_point_in_time" {
    for_each = length(keys(var.restore_to_point_in_time)) == 0 ? [] : [var.restore_to_point_in_time]
  
    content {
      source_cluster_identifier  = restore_to_point_in_time.value.source_cluster_identifier
      restore_type               = lookup(restore_to_point_in_time.value,"restore_type", null)
      use_latest_restorable_time = lookup(restore_to_point_in_time.value,"use_latest_restorable_time", null)
      restore_to_time            = lookup(restore_to_point_in_time.value,"restore_to_time", null)
    }
  }

  lifecycle {
    ignore_changes = [
      replication_source_identifier,
      global_cluster_identifier,
    ]
  }
  
  tags = {
    Name        = "${var.ecs_cluster_name}-rds-aurora-cluster"
    Environment = var.ecs_cluster_name
  }

}

resource"aws_rds_cluster_instance""rds" {
  for_each = var.create_cluster ? var.instances : {}
  identifier                            = var.instances_use_identifier_prefix ? null : lookup(each.value,"identifier","${var.ecs_cluster_name}-${each.key}")
  identifier_prefix                     = var.instances_use_identifier_prefix ? lookup(each.value,"identifier_prefix","${var.ecs_cluster_name}-${each.key}-") : null
  cluster_identifier                    = try(aws_rds_cluster.rds[0].id,"")
  engine                                = var.engine
  engine_version                        = var.engine_version
  instance_class                        = lookup(each.value,"instance_class", var.instance_class)
  publicly_accessible                   = lookup(each.value,"publicly_accessible", var.publicly_accessible)
  db_subnet_group_name                  = "${var.ecs_cluster_name}-rds-aurora-dsg"
  db_parameter_group_name               = "${var.ecs_cluster_name}-aurora-mysql57-pg" 
  apply_immediately                     = lookup(each.value,"apply_immediately", var.apply_immediately)
  monitoring_role_arn                   = var.create_monitoring_role ? join("", aws_iam_role.rds_enhanced_monitoring.*.arn) : var.monitoring_role_arn 
  monitoring_interval                   = lookup(each.value,"monitoring_interval", var.monitoring_interval)
  promotion_tier                        = lookup(each.value,"promotion_tier", null)
  availability_zone                     = lookup(each.value,"availability_zone", null)
  preferred_maintenance_window          = lookup(each.value,"preferred_maintenance_window", var.preferred_maintenance_window)
  auto_minor_version_upgrade            = lookup(each.value,"auto_minor_version_upgrade", var.auto_minor_version_upgrade)
  performance_insights_enabled          = lookup(each.value,"performance_insights_enabled", var.performance_insights_enabled)
  performance_insights_kms_key_id       = lookup(each.value,"performance_insights_kms_key_id", var.performance_insights_kms_key_id)
  performance_insights_retention_period = lookup(each.value,"performance_insights_retention_period", var.performance_insights_retention_period)
  copy_tags_to_snapshot                 = lookup(each.value,"copy_tags_to_snapshot", var.copy_tags_to_snapshot)
  ca_cert_identifier                    = var.ca_cert_identifier
  timeouts {
    create = lookup(var.instance_timeouts,"create", null)
    update = lookup(var.instance_timeouts,"update", null)
    delete = lookup(var.instance_timeouts,"delete", null)
  }
  tags = {
    Name        = "${var.ecs_cluster_name}-rds-aurora-reader"
    Environment = var.ecs_cluster_name
  }
}

resource"aws_rds_cluster_endpoint""rds" {
  for_each = var.create_cluster ? var.endpoints : tomap({})
  cluster_identifier          = try(aws_rds_cluster.rds[0].id,"")
  cluster_endpoint_identifier = each.value.identifier
  custom_endpoint_type        = each.value.type
  static_members   = lookup(each.value,"static_members", null)
  excluded_members = lookup(each.value,"excluded_members", null)
  depends_on = [
    aws_rds_cluster_instance.rds
  ]
  tags = {
    Name        = "${var.ecs_cluster_name}-rds-aurora-endpoint"
    Environment = var.ecs_cluster_name
  }
}

resource"aws_rds_cluster_role_association""rds" {
  db_cluster_identifier = try(aws_rds_cluster.rds[0].id,"")
  feature_name          = "" 
  role_arn              = var.iam_role_arn
}

data"aws_iam_policy_document""monitoring_rds_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource"aws_iam_role""rds_enhanced_monitoring" {
  count       = var.create_cluster && var.create_monitoring_role && var.monitoring_interval > 0 ? 1 : 0
  name        = var.iam_role_use_name_prefix ? null : var.iam_role_name
  name_prefix = var.iam_role_use_name_prefix ?"${var.iam_role_name}-" : null
  description = var.iam_role_description
  path        = var.iam_role_path
  assume_role_policy    = data.aws_iam_policy_document.monitoring_rds_assume_role.json
  managed_policy_arns   = var.iam_role_managed_policy_arns
  permissions_boundary  = var.iam_role_permissions_boundary
  force_detach_policies = var.iam_role_force_detach_policies
  max_session_duration  = var.iam_role_max_session_duration
  tags = {
    Name        = "${var.ecs_cluster_name}-rds-aurora-iam"
    Environment = var.ecs_cluster_name
  }
}

resource"aws_iam_role_policy_attachment""rds_enhanced_monitoring" {
  count      = var.create_cluster && var.create_monitoring_role && var.monitoring_interval > 0 ? 1 : 0
  role       = aws_iam_role.rds_enhanced_monitoring[0].name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource"aws_appautoscaling_target""rds" {
  max_capacity       = var.autoscaling_max_capacity
  min_capacity       = var.autoscaling_min_capacity
  resource_id        = "cluster:${try(aws_rds_cluster.rds[0].cluster_identifier,"")}"
  scalable_dimension = "rds:cluster:ReadReplicaCount"
  service_namespace  = "rds"
}

resource"aws_appautoscaling_policy""rds" {
  name               = "target-metric"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "cluster:${try(aws_rds_cluster.rds[0].cluster_identifier,"")}"
  scalable_dimension = "rds:cluster:ReadReplicaCount"
  service_namespace  = "rds"
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = var.predefined_metric_type
    }
    scale_in_cooldown  = var.autoscaling_scale_in_cooldown
    scale_out_cooldown = var.autoscaling_scale_out_cooldown
    target_value       = var.predefined_metric_type == "RDSReaderAverageCPUUtilization" ? var.autoscaling_target_cpu : var.autoscaling_target_connections
  }
  depends_on = [
    aws_appautoscaling_target.rds
  ]
}

resource"aws_security_group""rds" {
  name        = var.security_group_use_name_prefix ? null : var.ecs_cluster_name
  name_prefix = var.security_group_use_name_prefix ?"${var.ecs_cluster_name}-" : null
  vpc_id      = data.aws_alb.alb.vpc_id 
  description = coalesce(var.security_group_description,"Control traffic to/from RDS Aurora ${var.ecs_cluster_name}")
  tags = {
    Name        = "${var.ecs_cluster_name}-rds-aurora-sg"
    Environment = var.ecs_cluster_name
  }
}

resource"aws_security_group_rule""default_ingress" {
  description = "From allowed SGs"
  type                     = "ingress"
  from_port                = var.port
  to_port                  = var.port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.rds.id 
  security_group_id        = join("", aws_security_group.rds.*.id) 
}

resource"aws_security_group_rule""cidr_ingress" {
  description = "From allowed CIDRs"
  type              = "ingress"
  from_port         = var.port
  to_port           = var.port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = join("", aws_security_group.rds.*.id) 
}

resource"aws_security_group_rule""egress" {
  for_each = var.create_cluster && var.create_security_group ? var.security_group_egress_rules : {}
  type              = "egress"
  from_port         = lookup(each.value,"from_port", var.port)
  to_port           = lookup(each.value,"to_port", var.port)
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description              = lookup(each.value,"description", null)
  ipv6_cidr_blocks         = lookup(each.value,"ipv6_cidr_blocks", null)
  prefix_list_ids          = lookup(each.value,"prefix_list_ids", null)
  source_security_group_id = lookup(each.value,"source_security_group_id", null)
  security_group_id        = join("", aws_security_group.rds.*.id)
}
