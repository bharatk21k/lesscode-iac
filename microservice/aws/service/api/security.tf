# Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "ecs_tasks" {
  name        = "${var.ecs_cluster_name}-${var.name}-sg"
  description = "allow inbound access from the ALB only"
  vpc_id      = data.aws_alb.alb.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = var.service_port
    to_port         = var.service_port
    security_groups = [data.aws_security_group.lb_security_group.id]
  }

  ingress {
    description = "EFS mount target"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    security_groups = ["sg-0b9e0d2f9b803b0a8"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}