provider "aws" {
  alias  = "replica1"
  region = var.replica1_region
}

resource "aws_kms_replica_key" "replica1" {
  provider = aws.replica1
  description             = "Multi-Region replica key for ${var.partition_name}"
  deletion_window_in_days = 7
  primary_key_arn         = aws_kms_key.primary.arn
  //enabled = true

  //key_material_base64 = var.key
}

resource "aws_kms_alias" "replica1" {
  provider = aws.replica1
  name          = "alias/${var.partition_name}"
  target_key_id = aws_kms_replica_key.replica1.key_id
}