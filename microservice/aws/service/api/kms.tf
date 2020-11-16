resource "aws_kms_key" "main" {
  description             = data.aws_ecs_cluster.ecs.cluster_name
  deletion_window_in_days = 10
  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Id": "key-default-1",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": var.task_role_arn
            },
            "Action": "kms:*",
            "Resource": "*"
        }
    ]
  }
  POLICY
}

resource "aws_kms_alias" "main" {
  name          = "alias/${data.aws_ecs_cluster.ecs.cluster_name}"
  target_key_id = aws_kms_key.main.key_id
}
