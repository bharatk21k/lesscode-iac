output "ecs_task" {
    value = aws_ecs_task_definition.task
}

output "ecs_service" {
    value = aws_ecs_service.service
}

