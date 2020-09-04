
# outputs.tf
output "alb_dns_name" {
  value = "${aws_alb.main.dns_name}"
}

out "aws_alb_listener" {
  type = object
  value = ${aws_alb_listener.default}
}


