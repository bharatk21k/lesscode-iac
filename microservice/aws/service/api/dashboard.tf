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
               "title": "${data.aws_ecs_cluster.ecs.cluster_name}-${var.name}-20X"
            }
         },
         {
            "type":"metric",
            "x":0,
            "y":0,
            "width":12,
            "height":6,
            "properties":{
               "metrics":[
                  [ "${data.aws_ecs_cluster.ecs.cluster_name}", "${data.aws_ecs_cluster.ecs.cluster_name}-${var.name}-400" ]
               ],
               "view": "timeSeries",
               "stacked": false,
               "period": 60,
               "stat": "Sum",
               "region": "${var.region}",
               "title": "${data.aws_ecs_cluster.ecs.cluster_name}-${var.name}-400"
            }
         },
         {
            "type":"metric",
            "x":0,
            "y":0,
            "width":12,
            "height":6,
            "properties":{
               "metrics":[
                  [ "${data.aws_ecs_cluster.ecs.cluster_name}", "${data.aws_ecs_cluster.ecs.cluster_name}-${var.name}-401" ]
               ],
               "view": "timeSeries",
               "stacked": false,
               "period": 60,
               "stat": "Sum",
               "region": "${var.region}",
               "title": "${data.aws_ecs_cluster.ecs.cluster_name}-${var.name}-500"
            }
         },
         {
            "type":"metric",
            "x":0,
            "y":0,
            "width":12,
            "height":6,
            "properties":{
               "metrics":[
                  [ "${data.aws_ecs_cluster.ecs.cluster_name}", "${data.aws_ecs_cluster.ecs.cluster_name}-${var.name}-500" ]
               ],
               "view": "timeSeries",
               "stacked": false,
               "period": 60,
               "stat": "Sum",
               "region": "${var.region}",
               "title": "${data.aws_ecs_cluster.ecs.cluster_name}-${var.name}-40"
            }
         }
      ]
   }
   EOF
}