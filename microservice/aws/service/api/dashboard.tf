resource "aws_cloudwatch_dashboard" "main" {
   dashboard_name = "${data.aws_ecs_cluster.ecs.cluster_name}-${var.name}"

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
                  "metrics": [
                     [ "AWS/ECS", "MemoryUtilization", "ServiceName", "${var.name}", "ClusterName", "${data.aws_ecs_cluster.ecs.cluster_name}" ]
                  ],
                  "view": "timeSeries",
                  "region": "${var.region}",
                  "period": 60,
                  "stacked": true,
                  "title": "MEM %"
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
                     [ "AWS/ECS", "CPUUtilization", "ServiceName", "${var.name}", "ClusterName", "${data.aws_ecs_cluster.ecs.cluster_name}" ]
                  ],
                  "view": "timeSeries",
                  "region": "${var.region}",
                  "period": 60,
                  "stacked": true,
                  "title": "CPU %"
            }
         },
         {
            count = length(var.metrics_count)
            "type":"metric",
            "x":0,
            "y":0,
            "width":8,
            "height":4,
            "properties":{
                  "metrics": [
                     [ "${data.aws_ecs_cluster.ecs.cluster_name}","count-${var.metrics_count[count.index]}"],
                     [ { "expression": "SUM(METRICS())", "label": "count", "id": "e3" } ]
                  ],
                  "view": "timeSeries",
                  "region": "${var.region}",
                  "period": 60,
                  "stacked": false,
                  "stat": "Sum",
                  "title": "${var.metrics_count[count.index]}X- Count"
            }
         },
         {
            count = length(var.metrics_p95)
            "type":"metric",
            "x":0,
            "y":0,
            "width":8,
            "height":4,
            "properties":{
                  "metrics": [
                     [ "${data.aws_ecs_cluster.ecs.cluster_name}","latency-${var.metrics_count[count.index]}"]
                  ],
                  "view": "timeSeries",
                  "region": "${var.region}",
                  "period": 60,
                  "stacked": false,
                  "stat": "p95",
                  "title": "${var.metrics_count[count.index]}X - p95"
            }
         }
      ]
   }
   EOF
}