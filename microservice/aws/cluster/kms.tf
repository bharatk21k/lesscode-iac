resource "aws_kms_key" "primary" {
  description             = "Multi-Region primary key for ${var.ecs_cluster_name}"
  deletion_window_in_days = 7
  multi_region            = true
  enable_key_rotation = true

  //key_material_base64 = var.key
}

resource "aws_kms_alias" "alias" {
  name          =  "alias/${var.ecs_cluster_name}"
  target_key_id = aws_kms_key.primary.key_id
}
