# alb.tf

resource "aws_alb" "main" {
  name            = "${var.ecs_cluster_name}-load-balancer"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.lb.id]
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "default" {
  load_balancer_arn = aws_alb.main.id
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_certificate

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Powered by Lesscode!"
      status_code  = "200"
    }
  }
}