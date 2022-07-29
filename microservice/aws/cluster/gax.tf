resource "aws_globalaccelerator_accelerator" "gax" {
  name            = var.ecs_cluster_name
  ip_address_type = "IPV4"
  enabled         = true
}


resource "aws_globalaccelerator_listener" "https" {
  accelerator_arn = aws_globalaccelerator_accelerator.gax.id
  protocol        = "TCP"

  port_range {
    from_port = 80
    to_port   = var.tls_port
  }
}

resource "aws_globalaccelerator_endpoint_group" "alb" {
  listener_arn = aws_globalaccelerator_listener.https.id

  endpoint_configuration {
    endpoint_id = aws_alb_listener.default.arn
    weight      = 100
  }
}