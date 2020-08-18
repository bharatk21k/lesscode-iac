resource "aws_route53_record" "www-dev" {
  zone_id = "Z0269618GY7LD45GASL8"
  name    = "${var.ecs_cluster_name}"
  type    = "CNAME"
  ttl     = "5"

  weighted_routing_policy {
    weight = 10
  }

  set_identifier = "${aws_alb.main.dns_name}"
  records = [aws_alb.main.dns_name]
}