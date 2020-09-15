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
                  [ "${data.aws_ecs_cluster.ecs.cluster_name}","latency-20"]
               ],
               "view": "timeSeries",
               "stacked": false,
               "period": 1,
               "stat": "Sum",
               "region": "${var.region}",
               "title": "latency-20"
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
                     [ "${data.aws_ecs_cluster.ecs.cluster_name}","count-20"],
                     [ { "expression": "SUM(METRICS())", "label": "count", "id": "e3" } ]
                  ],
                  "view": "timeSeries",
                  "region": "${var.region}",
                  "period": 1,
                  "stacked": false,
                  "stat": "Sum",
                  "title": "count-20"
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
                     [ "${data.aws_ecs_cluster.ecs.cluster_name}","latency-20"]
                  ],
                  "view": "timeSeries",
                  "region": "${var.region}",
                  "period": 1,
                  "stacked": false,
                  "stat": "p95",
                  "title": "p95-20"
            }
         }
      ]
   }
   EOF
}