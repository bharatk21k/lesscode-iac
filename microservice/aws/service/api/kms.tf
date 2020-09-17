resource "aws_kms_key" "main" {
  description             = data.aws_ecs_cluster.ecs.cluster_name
  deletion_window_in_days = 10
  enable_key_rotation = true
}

resource "aws_kms_alias" "main" {
  name          = "alias/${data.aws_ecs_cluster.ecs.cluster_name}"
  target_key_id = aws_kms_key.main.key_id
}