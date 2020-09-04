
# outputs.tf
output "alb_dns_name" {
  value = "${aws_alb.main.dns_name}"
}

out "aws_alb_listener" {
  value = ${aws_alb_listener.default.arn}
}


