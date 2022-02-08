data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {
}

data "aws_ecs_cluster" "ecs_cluster_name" {
  cluster_name = "${var.ecs_cluster_name}-cluster"
}

data "aws_vpc" "vpc" {
  tags = {
    Name = var.ecs_cluster_name
  }
}

data "aws_subnet_ids" "private" {
 vpc_id = data.aws_vpc.vpc.id
 filter {
    name = "tag:subId"
    values = ["${var.ecs_cluster_name}-private-*"]
 }
}

resource "aws_iam_service_linked_role" "os" {
  aws_service_name = "es.amazonaws.com"
}

resource "null_resource" "service_linked_role" {
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command = <<-COMMAND
      aws iam create-service-linked-role --aws-service-name es.amazonaws.com
    COMMAND
    on_failure = continue
  }
}

data "aws_iam_role" "service_linked_role" {
  name = "AWSServiceRoleForAmazonOpenSearchService"
  depends_on = [
    null_resource.service_linked_role
  ]
}

resource "aws_elasticsearch_domain" "opensearch" {
  domain_name = "${var.ecs_cluster_name}-${var.name}"
  elasticsearch_version = var.opensearch_version

  cluster_config {
    instance_count = var.data_instance_count
    instance_type = var.data_instance_type
    zone_awareness_enabled = (var.availability_zones > 1) ? true : false

    dynamic "zone_awareness_config" {
      for_each = (var.availability_zones > 1) ? [var.availability_zones] : []
      content {
        availability_zone_count = zone_awareness_config.value
      }
    }
  }

  advanced_security_options {
    enabled                        = true
    internal_user_database_enabled = true
    master_user_options {
      master_user_name = "admin"
      master_user_password = "Admin@1231"
    }
  }

  ebs_options {
    ebs_enabled = true
    volume_size = var.data_instance_storage
  }

  vpc_options {
    subnet_ids = "${data.aws_subnet_ids.private.ids}"
    security_group_ids = [aws_security_group.opensearch.id]
  }

    advanced_options = {
      "rest.action.multi.allow_explicit_index" = "true"
  }
    access_policies = <<CONFIG
  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Action": "es:*",
              "Principal": "*",
              "Effect": "Allow",
              "Resource": "arn:aws:es:us-west-2:${data.aws_caller_identity.current.account_id}:domain/${var.ecs_cluster_name}-${var.name}/*"
          }
      ]  
  }
CONFIG

    #depends_on = [aws_iam_service_linked_role.es]

  encrypt_at_rest {
    enabled = var.encrypt_at_rest
  }

  node_to_node_encryption {
    enabled = true
  }

  domain_endpoint_options {
    enforce_https = true
    tls_security_policy = "Policy-Min-TLS-1-0-2019-07"
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.opensearch_logs.arn
    log_type = "INDEX_SLOW_LOGS"
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.opensearch_logs.arn
    log_type = "SEARCH_SLOW_LOGS"
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.opensearch_logs.arn
    log_type = "ES_APPLICATION_LOGS"
  }

  tags = var.tags

  depends_on = [data.aws_iam_role.service_linked_role]
}

resource "aws_security_group" "opensearch" {
  name = "${var.ecs_cluster_name}-${var.name}-opensearch-sg"
  description = "${var.ecs_cluster_name}-${var.name}-security-group"
  vpc_id = data.aws_vpc.vpc.id

  egress {
    description = "Allow all outbound traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_security_group_rule" "opensearch" {
  description = "Cluster Subnets"
  security_group_id = aws_security_group.opensearch.id
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_cloudwatch_log_group" "opensearch_logs" {
  name = "opensearch/${var.ecs_cluster_name}-${var.name}"
}

resource "aws_cloudwatch_log_resource_policy" "opensearch_logs" {
  policy_name = "${var.ecs_cluster_name}-${var.name}"
  policy_document = data.aws_iam_policy_document.opensearch_logs.json
}

data "aws_iam_policy_document" "opensearch_logs" {
  statement {
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["es.amazonaws.com"]
    }
    actions = [
      "logs:PutLogEvents",
      "logs:PutLogEventsBatch",
      "logs:CreateLogStream",
    ]
    resources = [
      "arn:aws:logs:*"
    ]
  }
}
