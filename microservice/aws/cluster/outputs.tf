
# outputs.tf

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "aws_security_group_lb_id" {
  value ="${aws_security_group.lb.id}"
}

output "alb_dns_name" {
  value = "${aws_alb.main.dns_name}"
}

output "aws_alb_listener_arn" {
  value = "${aws_alb_listener.default.arn}"
}

output "subnets_private_ids" {
  value = [aws_subnet.private.*.id]
}


