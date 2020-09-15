resource "aws_cloudfront_distribution" "default" {
  origin {
    domain_name = var.alb_dns_name
    origin_id   = var.alb_dns_name

    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "/"

  
  aliases = ["${var.domain}"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET","HEAD"]
    target_origin_id = var.alb_dns_name

    forwarded_values {
      query_string = true
      headers      = ["Origin","Accept-Encoding","Authorization","Host","CloudFront-Viewer-Country"]

      cookies {
        forward = "all"
      }
      # for API's we do not want to cache anything
      min_ttl                = 0
      default_ttl            = 0
      max_ttl                = 0
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = var.env
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_certificate
    minimum_protocol_version = "TLSv1"
    ssl_support_method       = "sni-only"
  }
}