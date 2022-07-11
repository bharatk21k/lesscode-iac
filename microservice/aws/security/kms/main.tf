provider "aws" {
  alias  = "primary"
  region = var.region
}

data "aws_kms_key" "primary" {
  provider = aws.primary
  key_id = "alias/${var.ecs_cluster_name}-${var.region}-${var.tenant_id}"
}


resource "aws_kms_external_key" "primary" {
  count = data.aws_kms_key.primary == null ? 1 : 0
  provider = aws.primary

  description             = "Multi-Region primary key for ${var.tenant_id}"
  deletion_window_in_days = 30
  multi_region            = true
  enabled                 = true

  key_material_base64 = var.key
}

resource "aws_kms_alias" "alias" {
  count = data.aws_kms_key.primary == null ? 1 : 0
  name          = "alias/${var.ecs_cluster_name}-${var.region}-${var.tenant_id}"
  target_key_id = aws_kms_external_key.primary[0].id
}