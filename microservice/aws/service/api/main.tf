data "aws_ecs_cluster" "ecs" {
  cluster_name = "${var.ecs_cluster_name}-cluster"

}

data "aws_alb" "alb" {
  name = "${var.ecs_cluster_name}-load-balancer"
}

data "aws_lb_listener" "listener" {
  load_balancer_arn = data.aws_alb.alb.arn
  port = var.tls_port
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_alb.alb.vpc_id
  tags = {
    Name = "${var.ecs_cluster_name}"
  }
}

data "aws_security_group" "lb_security_group" {
  name = "${var.ecs_cluster_name}-load-balancer-security-group"
}


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

data "template_file" "service" {
  template = file("${path.module}/templates/ecs/taskdef.json.tpl")

  vars = {
    name                = var.name
    ecs_cluster_name    = var.ecs_cluster_name
    service_image       = var.service_image
    service_port        = var.service_port
    fargate_cpu         = var.fargate_cpu
    fargate_memory      = var.fargate_memory
    region              = var.region
    aws_log_group       = aws_cloudwatch_log_group.service_log_group.name

  }
}

resource "aws_ecs_task_definition" "task" {
  family                   = var.name
  task_role_arn            = var.task_role_arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.service.rendered
  
  volume {
    name = "${var.ecs_cluster_name}-${var.name}-storage"

    efs_volume_configuration {
      file_system_id          = "fs-0ecaeb0b"
      root_directory          = "/"
      transit_encryption      = "ENABLED"
      transit_encryption_port = 2999
    }
  }

  depends_on =[data.aws_ecs_cluster.ecs, data.aws_lb_listener.listener]
}

resource "aws_ecs_service" "service" {
  name            = var.name
  cluster         = data.aws_ecs_cluster.ecs.arn
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = var.service_count_min
  launch_type     = "FARGATE"
  force_new_deployment = "true"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = data.aws_subnet_ids.private.ids
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.service.id
    container_name   = var.name
    container_port   = var.service_port
  }

  #depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role]
}

resource "aws_alb_target_group" "service" {
  name        = "${var.ecs_cluster_name}-${var.name}-tg"
  port        = var.service_port
  protocol    = "HTTP"
  vpc_id      = data.aws_alb.alb.vpc_id
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
  
  listener_arn = data.aws_lb_listener.listener.arn
  priority     = var.priority

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