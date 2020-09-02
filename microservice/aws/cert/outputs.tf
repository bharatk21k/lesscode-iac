
# outputs.tf
output "acm_certificate" {
  value = "${aws_acm_certificate_validation.default.certificate_arn}"
}


