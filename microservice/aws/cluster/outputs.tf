
# outputs.tf
output "alb_dns_name" {
  value = "${aws_alb.main.dns_name}"
}

output "aws_alb_listener_arn" {
  value = "${aws_alb_listener.default.arn}"
}


