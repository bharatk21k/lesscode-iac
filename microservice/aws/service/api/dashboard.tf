resource "aws_cloudwatch_dashboard" "main" {
   count = length(var.metrics)
   dashboard_name = "${data.aws_ecs_cluster.ecs.cluster_name}-${var.name}-${var.metrics[count.index]}"

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
                  [ "${data.aws_ecs_cluster.ecs.cluster_name}", "${data.aws_ecs_cluster.ecs.cluster_name}-${var.name}-${var.metrics[count.index]}" ]
               ],
               "view": "timeSeries",
               "stacked": false,
               "period": 60,
               "stat": "Sum",
               "region": "${var.region}",
               "title": "${data.aws_ecs_cluster.ecs.cluster_name}-${var.name}-${var.metrics[count.index]}"
            }
         }
      ]
   }
   EOF
}