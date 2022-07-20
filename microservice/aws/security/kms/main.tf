provider "aws" {
  alias  = "primary"
  region = var.region
}


resource "aws_kms_key" "primary" {
  provider = aws.primary
  description             = "Multi-Region primary key for ${var.tenant_id}"
  deletion_window_in_days = 7
  multi_region            = true
  enable_key_rotation = true

  //key_material_base64 = var.key
}

resource "aws_kms_alias" "alias" {
  name          = "alias/${var.tenant_id}"
  target_key_id = aws_kms_key.primary.id
}