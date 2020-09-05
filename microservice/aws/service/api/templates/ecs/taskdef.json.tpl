[
    {
      "name": "${name}",
      "image": "${app_image}",
      "cpu": ${fargate_cpu},
      "memory": ${fargate_memory},
      "networkMode": "awsvpc",
      "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-group": "${aws_log_group}",
            "awslogs-region": "${region}",
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