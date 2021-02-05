resource "aws_route53_record" "default" {
  zone_id = var.zoneid
  name    = var.domain
  type    = "CNAME"
  ttl     = "5"

  weighted_routing_policy {
    weight = 10
  }

  set_identifier = aws_cloudfront_distribution.default.domain_name
  records = [aws_cloudfront_distribution.default.domain_name]
}