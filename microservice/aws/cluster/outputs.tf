
# outputs.tf

output "aws_security_group_lb_id" {
  value = "${aws_security_group.lb.id}"
}

output "ecs_cluster_arn" {
  value = "${aws_ecs_cluster.main.id}"
}

output "alb_dns_name" {
  value = "${aws_alb.main.dns_name}"
}

output "aws_alb_listener_arn" {
  value = "${aws_alb_listener.default.arn}"
}


