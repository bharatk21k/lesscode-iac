[
    {
      "name": "${name}",
      "image": "nginx:latest",
      "cpu": ${fargate_cpu},
      "memory": ${fargate_memory},
      "networkMode": "awsvpc",
      "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-group": "${ecs_cluster_name}/ecs/${name}",
            "awslogs-region": "${aws_region}",
            "awslogs-stream-prefix": "lc"
          }
      },
      "portMappings": [
        {
          "containerPort": ${app_port},
          "hostPort": ${app_port}
        }
      ]
    }
  ]