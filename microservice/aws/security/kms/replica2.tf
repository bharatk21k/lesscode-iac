provider "aws" {
  alias  = "replica2"
  region = var.replica2_region
}

resource "aws_kms_replica_external_key" "replica2" {
  provider = aws.replica2
  description             = "Multi-Region replica key"
  deletion_window_in_days = 7
  primary_key_arn         = aws_kms_external_key.primary[0].arn
  enabled = true

  key_material_base64 = var.key
}

resource "aws_kms_alias" "replica2" {
  provider = aws.replica2
  name          = "alias/${var.ecs_cluster_name}-${var.replica2_region}-${var.tenant_id}"
  target_key_id = aws_kms_replica_external_key.replica2.key_id
}