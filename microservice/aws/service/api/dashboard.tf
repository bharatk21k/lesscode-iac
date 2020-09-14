resource "aws_cloudwatch_dashboard" "main" {
   dashboard_name = "${data.aws_ecs_cluster.ecs.cluster_name}-${var.name}"

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
                  [ "${data.aws_ecs_cluster.ecs.cluster_name}", "${data.aws_ecs_cluster.ecs.cluster_name}-${var.name}-20" ]
               ],
               "view": "timeSeries",
               "stacked": false,
               "period": 60,
               "stat": "Sum",
               "region": "${var.region}",
               "title": "latency-20X"
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
                     [ "${data.aws_ecs_cluster.ecs.cluster_name}", "${data.aws_ecs_cluster.ecs.cluster_name}-${var.name}-20" ],
                     [ { "expression": "SUM(METRICS())", "label": "20X_count", "id": "e3" } ]
                  ],
                  "view": "timeSeries",
                  "region": "${var.region}",
                  "period": 60,
                  "stacked": false,
                  "stat": "Sum",
                  "title":"count-20X"
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
                     [ "${data.aws_ecs_cluster.ecs.cluster_name}", "${data.aws_ecs_cluster.ecs.cluster_name}-${var.name}-50" ],
                     [ { "expression": "SUM(METRICS())", "label": "50X_count", "id": "e3" } ]
                  ],
                  "view": "timeSeries",
                  "region": "${var.region}",
                  "period": 60,
                  "stacked": false,
                  "stat": "Sum",
                  "title":"count-50X"
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
                     [ "${data.aws_ecs_cluster.ecs.cluster_name}", "${data.aws_ecs_cluster.ecs.cluster_name}-${var.name}-400" ],
                     [ { "expression": "SUM(METRICS())", "label": "400_count", "id": "e3" } ]
                  ],
                  "view": "timeSeries",
                  "region": "${var.region}",
                  "period": 60,
                  "stacked": false,
                  "stat": "Sum",
                  "title":"count-400"
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
                     [ "${data.aws_ecs_cluster.ecs.cluster_name}", "${data.aws_ecs_cluster.ecs.cluster_name}-${var.name}-401" ],
                     [ { "expression": "SUM(METRICS())", "label": "401_count", "id": "e3" } ]
                  ],
                  "view": "timeSeries",
                  "region": "${var.region}",
                  "period": 60,
                  "stacked": false,
                  "stat": "Sum",
                  "title":"count-401"
            }
         },
      ]
   }
   EOF
}