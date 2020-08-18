
# outputs.tf

output "alb_hostname" {
  value = aws_alb.main.dns_name
}

output "route53_cname" {
  value = aws_route53_record.www-dev.fqdn
}

