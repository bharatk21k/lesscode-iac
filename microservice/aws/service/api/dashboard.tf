resource "aws_cloudwatch_dashboard" "main" {
   dashboard_name = "${data.aws_ecs_cluster.ecs.cluster_name}-${var.name}-20X"

   dashboard_body = <<EOF
   {
      "widgets": [
         {
            "type":"metric",
            "x":0,
            "y":0,
            "width":8,
            "height":4,
            "properties":{
               "metrics":[
                  [ "${data.aws_ecs_cluster.ecs.cluster_name}-${var.name}-20", "latency" ]
               ],
               "view": "timeSeries",
               "stacked": false,
               "period": 60,
               "stat": "Sum",
               "region": "${var.region}",
               "title": "latency"
            }
         },
         {
            "type":"metric",
            "x":0,
            "y":0,
            "width":8,
            "height":4,
            "properties":{
                  "metrics": [
                     [ "${data.aws_ecs_cluster.ecs.cluster_name}-${var.name}-20", "count" ],
                     [ { "expression": "SUM(METRICS())", "label": "count", "id": "e3" } ]
                  ],
                  "view": "timeSeries",
                  "region": "${var.region}",
                  "period": 60,
                  "stacked": false,
                  "stat": "Sum",
                  "title": "count"
            }
         },
         {
            "type":"metric",
            "x":0,
            "y":0,
            "width":8,
            "height":4,
            "properties":{
                  "metrics": [
                     [ "${data.aws_ecs_cluster.ecs.cluster_name}-${var.name}-20", "count" ],
                     [ { "expression": "SUM(METRICS())", "label": "count", "id": "e3" } ]
                  ],
                  "view": "timeSeries",
                  "region": "${var.region}",
                  "period": 60,
                  "stacked": false,
                  "stat": "p95",
                  "title": "p95"
            }
         }
      ]
   }
   EOF
}