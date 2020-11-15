resource "aws_cloudwatch_dashboard" "resource" {
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
                     [ "${data.aws_ecs_cluster.ecs.cluster_name}","latency-2"]
                  ],
                  "view": "timeSeries",
                  "region": "${var.region}",
                  "period": 60,
                  "stacked": false,
                  "stat": "p95",
                  "title": "2X - p95"
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
                     [ "${data.aws_ecs_cluster.ecs.cluster_name}","count-2"],
                     [ { "expression": "SUM(METRICS())", "label": "count", "id": "e3" } ]
                  ],
                  "view": "timeSeries",
                  "region": "${var.region}",
                  "period": 60,
                  "stacked": false,
                  "stat": "Sum",
                  "title": "2X- Count"
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
                     [ "${data.aws_ecs_cluster.ecs.cluster_name}","count-3"],
                     [ { "expression": "SUM(METRICS())", "label": "count", "id": "e3" } ]
                  ],
                  "view": "timeSeries",
                  "region": "${var.region}",
                  "period": 60,
                  "stacked": false,
                  "stat": "Sum",
                  "title": "3X- Count"
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
                     [ "${data.aws_ecs_cluster.ecs.cluster_name}","count-4"],
                     [ { "expression": "SUM(METRICS())", "label": "count", "id": "e3" } ]
                  ],
                  "view": "timeSeries",
                  "region": "${var.region}",
                  "period": 60,
                  "stacked": false,
                  "stat": "Sum",
                  "title": "4X- Count"
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
                     [ "${data.aws_ecs_cluster.ecs.cluster_name}","count-5"],
                     [ { "expression": "SUM(METRICS())", "label": "count", "id": "e3" } ]
                  ],
                  "view": "timeSeries",
                  "region": "${var.region}",
                  "period": 60,
                  "stacked": false,
                  "stat": "Sum",
                  "title": "5X- Count"
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
         }
      ]
   }
   EOF
}