
resource "aws_kms_external_key" "main" {
  description             = var.ecs_cluster_name
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "main" {
  name          = "alias/${var.ecs_cluster_name}"
  target_key_id = aws_kms_external_key.main.id
}