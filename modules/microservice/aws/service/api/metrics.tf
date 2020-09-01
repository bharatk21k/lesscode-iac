resource "aws_cloudwatch_log_metric_filter" "count_403" {
  name           = "count_403"
  pattern        = "{$.status = 403}"
  log_group_name = aws_cloudwatch_log_group.api_store_log_group.name

  metric_transformation {
    name      = "count_403"
    namespace = aws_ecs_cluster.main.name
    value     = "1"
  }
}
resource "aws_cloudwatch_log_metric_filter" "count_401" {
  name           = "count_401"
  pattern        = "{$.status = 401}"
  log_group_name = aws_cloudwatch_log_group.api_store_log_group.name

  metric_transformation {
    name      = "count_401"
    namespace = aws_ecs_cluster.main.name
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "latency_200" {
  name           = "latency_200"
  pattern        = "{$.status = 200}"
  log_group_name = aws_cloudwatch_log_group.api_store_log_group.name

  metric_transformation {
    name      = "latency_200"
    namespace = aws_ecs_cluster.main.name
    value     = "$.latency"
  }
}
resource "aws_cloudwatch_log_metric_filter" "count_200" {
  name           = "count_200"
  pattern        = "{$.status = 200}"
  log_group_name = aws_cloudwatch_log_group.api_store_log_group.name

  metric_transformation {
    name      = "count_200"
    namespace = aws_ecs_cluster.main.name
    value     = "1"
  }
}

