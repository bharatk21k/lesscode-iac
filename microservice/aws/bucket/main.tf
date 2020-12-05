resource "aws_s3_bucket" "default" {
  bucket = var.domain
  acl    = "private"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["https://${var.domain}"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
  tags = {
    Name        = var.domain
    Environment = var.env
  }
}