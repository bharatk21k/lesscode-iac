# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "api_store_log_group" {
  name              = "/ecs/api-store"
  retention_in_days = 30

  tags = {
    Name = "cb-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "api_store_log_stream" {
  name           = "${var.ecs_cluster_name}-api-store-log-stream"
  log_group_name = aws_cloudwatch_log_group.api_store_log_group.name
}



data "template_file" "api_store" {
  template = file("./templates/ecs/svc-api-store.json.tpl")

  vars = {
    app_image      = var.app_image
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
  }
}

resource "aws_ecs_task_definition" "api-store" {
  family                   = "${var.ecs_cluster_name}-api-store-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.api_store.rendered
}

resource "aws_ecs_service" "api_store" {
  name            = "${var.ecs_cluster_name}-api-store-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.api-store.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"
  force_new_deployment = "true"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.api_store.id
    container_name   = "api-store"
    container_port   = 8080
  }

  depends_on = [aws_alb_listener.front_end, aws_iam_role_policy_attachment.ecs_task_execution_role]
}

resource "aws_alb_target_group" "api_store" {
  name        = "${var.ecs_cluster_name}-api-store-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }
}

resource "aws_lb_listener_rule" "api_store" {
  
  listener_arn = "${aws_alb_listener.front_end.arn}"
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.api_store.arn}"
  }

  condition {
    path_pattern {
      values = ["/api/store*"]
    }
  }
}