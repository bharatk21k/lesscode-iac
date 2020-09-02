
# outputs.tf
output "alb_dns_name" {
  value = "${aws_alb.main.dns_name}"
}

output "acm_certificate"{
  value = "${aws_acm_certificate.default.id}"
}


