

resource "aws_cloudwatch_log_metric_filter" "latency" {
  count = length(var.metrics_p95)
  name  = "${data.aws_ecs_cluster.ecs.cluster_name}-${var.name}-${var.metrics_p95[count.index]}-latency"

  pattern        = "{$.status = ${var.metrics_p95[count.index]}*}"
  log_group_name = aws_cloudwatch_log_group.service_log_group.name

  metric_transformation {
    name      = "latency-${var.metrics_p95[count.index]}"
    namespace = data.aws_ecs_cluster.ecs.cluster_name
    value     = "$.latency"
  }
}

resource "aws_cloudwatch_log_metric_filter" "count" {
  count = length(var.metrics_count)
  name  = "${data.aws_ecs_cluster.ecs.cluster_name}-${var.name}-${var.metrics_count[count.index]}-count"

  pattern        = "{$.status = ${var.metrics_count[count.index]}*}"
  log_group_name = aws_cloudwatch_log_group.service_log_group.name

  metric_transformation {
    name      = "count-${var.metrics_count[count.index]}"
    namespace = data.aws_ecs_cluster.ecs.cluster_name
    value     = "1"
  }
}


