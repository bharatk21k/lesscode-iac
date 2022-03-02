resource "aws_cloudwatch_log_subscription_filter" "subscription" {
  name            = var.name
  log_group_name  = "service/${var.ecs_cluster_name}/${var.service_name}"
  filter_pattern  = var.filter_pattern
  destination_arn = var.service_arn
}