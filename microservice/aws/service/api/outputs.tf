output "ecs" {
    value = data.aws_ecs_cluster.ecs
}

output "alb" {
    value = data.aws_alb.alb
}

output "listener" {
    value = data.aws_lb_listener.listener
}

output "subnet" {
    value = data.aws_subnet_ids.private
}