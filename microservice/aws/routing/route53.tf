resource "aws_route53_record" "default" {
  zone_id = var.zoneid
  name    = var.domain
  type    = "CNAME"
  ttl     = "5"

  weighted_routing_policy {
    weight = 10
  }

  set_identifier = var.alb_dns_name
  records = [var.alb_dns_name]
}