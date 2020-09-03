
# outputs.tf
output "alb_dns_name" {
  value = "${aws_alb.main.dns_name}"
}

output "cluster_arn" {
  value = "${aws_ecs_cluster.main.arn}
}


