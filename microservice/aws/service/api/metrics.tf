

resource "aws_cloudwatch_log_metric_filter" "latency" {
  count = length(var.metrics)
  name  = "${data.aws_ecs_cluster.ecs.cluster_name}-${var.name}-${var.metrics[count.index]}-latency"

  pattern        = "{$.status = ${var.metrics[count.index]}*}"
  log_group_name = aws_cloudwatch_log_group.service_log_group.name

  metric_transformation {
    name      = "latency_${var.metrics[count.index]}"
    namespace = data.aws_ecs_cluster.ecs.cluster_name
    value     = "$.latency"
  }
}


