output "ecs_task" {
    value = aws_ecs_task_definition.task
}

output "ecs_service" {
    value = aws_ecs_service.service
}

output "ecs_policy" {
    value = data.aws_iam_policy_document.ecs_task_execution_role
}

output "id" {
  description = "The ID of the instance"
  value       = try(aws_instance.efs[0].id, "")
}

output "public_ip" {
  description = "The public IP address assigned to the instance"
  value       = try(aws_instance.efs[0].public_ip, "")
}
