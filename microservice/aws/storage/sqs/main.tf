resource "aws_sqs_queue" "queue_wo_dql" {
  name                      = "${var.ecs_cluster_name}-${var.name}"
  delay_seconds             = var.delay_seconds
  max_message_size          = var.max_message_size
  message_retention_seconds = var.message_retention_seconds

  count = var.dlq ? 0 : 1
  tags = {
    env = var.env
  }
}

resource "aws_sqs_queue" "queue_w_dql" {
  name                      = "${var.ecs_cluster_name}-${var.name}"
  delay_seconds             = var.delay_seconds
  max_message_size          = var.max_message_size
  message_retention_seconds = var.message_retention_seconds

  count = var.dlq ? 1 : 0
  redrive_policy = jsonencode({
    deadLetterTargetArn = var.dlq_arn 
    maxReceiveCount     = var.dlq_max_reeceive_count
  })
  
  tags = {
    env = var.env
  }
}