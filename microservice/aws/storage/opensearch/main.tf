module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 3.2.0"
  domain_name = "${var.cluster_name}-search.${data.aws_route53_zone.opensearch.name}"
  zone_id     = data.aws_route53_zone.opensearch.id
  wait_for_validation = true
  tags = var.tags
}

resource "aws_iam_service_linked_role" "es" {
    count            = var.create_service_role ? 1 : 0
    aws_service_name = "es.amazonaws.com"
    description      = "Allows Amazon ES to manage AWS resources for a domain on your behalf."
}

resource "aws_elasticsearch_domain" "opensearch" {
  domain_name           = "${var.cluster_name}-search"
  elasticsearch_version = "OpenSearch_${var.cluster_version}"
  cluster_config {
    dedicated_master_enabled = var.master_instance_enabled
    dedicated_master_count   = var.master_instance_enabled ? var.master_instance_count : null
    dedicated_master_type    = var.master_instance_enabled ? var.master_instance_type : null

    instance_count = var.instance_count
    instance_type  = var.instance_type

    warm_enabled = var.warm_instance_enabled
    warm_count   = var.warm_instance_enabled ? var.warm_instance_count : null
    warm_type    = var.warm_instance_enabled ? var.warm_instance_type : null

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
    internal_user_database_enabled = false
    
    master_user_options {
      master_user_arn = var.task_role_arn
    }
  }

  ebs_options {
    ebs_enabled = true
    volume_size = "50"
  }

  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
    custom_endpoint_enabled         = true
    custom_endpoint                 = "${var.cluster_name}-search.${data.aws_route53_zone.opensearch.name}"
    custom_endpoint_certificate_arn = module.acm.acm_certificate_arn
  }
  
  node_to_node_encryption {
    enabled = true
  }

  encrypt_at_rest {
    enabled    = true
    kms_key_id = var.encrypt_kms_key_id
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
            "Resource": "arn:aws:es:us-west-2:${account_id}:domain/${var.cluster_name}-search/*"
        }
    ]
}
CONFIG

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
}

resource "aws_security_group" "opensearch" {
  name = "${var.cluster_name}-search-sg"
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
  name = "opensearch/${var.cluster_name}-search"
}

resource "aws_cloudwatch_log_resource_policy" "opensearch_logs" {
  policy_name = "${var.cluster_name}-search"
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

resource "aws_route53_record" "opensearch" {
  zone_id = data.aws_route53_zone.opensearch.id
  name    = "${var.cluster_name}-search"
  type    = "CNAME"
  ttl     = "60"
  records = [aws_elasticsearch_domain.opensearch.endpoint]
}
