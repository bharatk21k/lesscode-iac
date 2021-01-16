# alb.tf

resource "aws_alb" "main" {
  name            = "${var.ecs_cluster_name}-load-balancer"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.lb.id]
  tags = {
    Name = var.ecs_cluster_name
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_lb_listener" "redirect" {
  load_balancer_arn = aws_alb.main.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "default" {
  load_balancer_arn = aws_alb.main.id
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.default.certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<html><h2>Powered by <a href='https://github.com/van001/lesscode-iac'> Lesscode! </a></h2></html>"
      status_code  = "200"
    }
  }
}