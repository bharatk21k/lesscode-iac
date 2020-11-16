data "template_file" "kms" {
   template = file("${path.module}/templates/kms/policy.json.tpl")
   
   vars = {
     resource = var.task_role_arn
   }
 }

resource "aws_kms_key" "main" {
  description             = data.aws_ecs_cluster.ecs.cluster_name
  deletion_window_in_days = 10
  policy = data.template_file.kms.rendered
}

resource "aws_kms_alias" "main" {
  name          = "alias/${data.aws_ecs_cluster.ecs.cluster_name}"
  target_key_id = aws_kms_key.main.key_id
}
