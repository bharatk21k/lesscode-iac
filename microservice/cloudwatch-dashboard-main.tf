resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.ecs_cluster_name}-main"

  dashboard_body = <<EOF
 {
   "widgets": [
       {
          "type":"metric",
          "x":0,
          "y":0,
          "width":12,
          "height":6,
          "properties":{
             "metrics":[
                [ "main-dev-us-west-2-cluster", "latency_200" ]
             ],
             "view": "timeSeries",
             "stacked": false,
             "period": 60,
             "stat": "Sum",
             "region":"${var.region}",
             "title":"200_latency"
          }
       },
       {
          "type":"metric",
          "x":0,
          "y":0,
          "width":12,
          "height":6,
          "properties":{
               "metrics": [
                  [ "main-dev-us-west-2-cluster", "count_200" ],
                  [ { "expression": "SUM(METRICS())", "label": "200_count", "id": "e3" } ]
               ],
               "view": "timeSeries",
               "region": "${var.region}",
               "period": 60,
               "stacked": false,
               "stat": "Sum",
               "title":"200_count"
          }
       }
   ]
 }
 EOF
}