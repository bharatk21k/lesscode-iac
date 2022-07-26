provider "aws" {
  alias  = "replica2"
  region = var.replica2_region
}

resource "aws_kms_replica_key" "replica2" {
  provider = aws.replica2
  description             = "Multi-Region replica key for ${var.partition_name}"
  deletion_window_in_days = 7
  primary_key_arn         = aws_kms_key.primary.arn
  //enabled = true

  //key_material_base64 = var.key
  depends_on = = [aws_kms_key.primary]
}

resource "aws_kms_alias" "replica2" {
  provider = aws.replica2
  name          = "alias/${var.partition_name}"
  target_key_id = aws_kms_replica_key.replica2.key_id
}