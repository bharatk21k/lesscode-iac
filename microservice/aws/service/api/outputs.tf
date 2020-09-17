output "ecs_task" {
    value = aws_ecs_task_definition.task
}

output "ecs_service" {
    value = aws_ecs_service.service
}

output "ecs_policy" {
    value = data.aws_iam_policy_document.ecs_task_execution_role
}

