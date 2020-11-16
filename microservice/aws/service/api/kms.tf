data "aws_iam_policy_document" "service" {
  statement {
    principals = ["arn:aws:iam::092166348842:root","${var.task_role_arn}"]
    actions   = ["*"]
    resources = ["*"]
  }
}
resource "aws_kms_key" "main" {
  description             = data.aws_ecs_cluster.ecs.cluster_name
  deletion_window_in_days = 10
  policy = data.aws_iam_policy_document.service.json
}

resource "aws_kms_alias" "main" {
  name          = "alias/${data.aws_ecs_cluster.ecs.cluster_name}"
  target_key_id = aws_kms_key.main.key_id
}
