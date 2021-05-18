resource "aws_sqs_queue" "sqs" {
  name                      = "${var.ecs_cluster_name}-${var.name}"
  message_retention_seconds = var.retention
  visibility_timeout_seconds = var.visibility

  redrive_policy = jsonencode({
    deadLetterTargetArn = var.dlq
    maxReceiveCount     = 5
  })

}