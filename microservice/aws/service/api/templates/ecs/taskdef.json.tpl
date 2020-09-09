[
    {
      "name": "${name}",
      "image": "${service_image}",
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
          "containerPort": ${service_port},
          "hostPort": ${service_port}
        }
      ]
    }
  ]