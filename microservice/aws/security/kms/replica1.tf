provider "aws" {
  alias  = "replica1"
  region = var.replica1_region
}

resource "aws_kms_replica_external_key" "replica1" {
  provider = aws.replica1
  description             = "Multi-Region replica key"
  deletion_window_in_days = 7
  primary_key_arn         = aws_kms_external_key.primary[0].arn
  enabled = true

  key_material_base64 = var.key
}

resource "aws_kms_alias" "replica1" {
  provider = aws.replica1
  name          = "alias/${var.ecs_cluster_name}-${var.replica1_region}-${var.tenant_id}"
  target_key_id = aws_kms_replica_external_key.replica1.key_id
}