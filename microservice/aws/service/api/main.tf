# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "service_log_group" {
  name              = "service/${var.ecs_cluster_name}/${var.name}"
  retention_in_days = 30

  tags = {
    Name = "service/${var.name}"
  }
}

resource "aws_cloudwatch_log_stream" "service_log_stream" {
  name           = "${var.ecs_cluster_name}-${var.name}-log-stream"
  log_group_name = aws_cloudwatch_log_group.service_log_group.name
}

resource "docker_image" "mydockerimage" {
  name = "nginx:latest"
}

data "template_file" "service" {
  template = file("./templates/ecs/taskdef.json.tpl")

  vars = {
    name                = var.name
    ecs_cluster_name    = var.ecs_cluster_name
    app_image           = var.app_image
    app_port            = var.app_port
    fargate_cpu         = var.fargate_cpu
    fargate_memory      = var.fargate_memory
    region              = var.region
    aws_log_group       = aws_cloudwatch_log_group.service_log_group.name

  }
}

resource "aws_ecs_task_definition" "service" {
  family                   = "${var.ecs_cluster_name}-${var.name}-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.service.rendered
}

resource "aws_ecs_service" "service" {
  name            = "${var.ecs_cluster_name}-${var.name}-service"
  cluster         = var.ecs_cluster_arn
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"
  force_new_deployment = "true"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = var.subnets_privates_ids
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.service.id
    container_name   = var.name
    container_port   = var.app_port
  }

  #depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role]
}

resource "aws_alb_target_group" "service" {
  name        = "${var.ecs_cluster_name}-${var.name}-tg"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
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

resource "aws_lb_listener_rule" "service" {
  
  listener_arn = var.aws_alb_listener_arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.service.arn
  }

  condition {
    path_pattern {
      values = ["${var.path}*"]
    }
  }
}