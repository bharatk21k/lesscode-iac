variable "name" {
    type = string
    default = "test"
}

variable "ecs_cluster_name" {
    type = string
    default = "main-dev-us-west-1-load-balancer-2104505543.us-east-1.elb.amazonaws.com"
}

variable "ecs_cluster_arn" {
    type = string
    default = "arn:aws:ecs:us-east-1:284832936816:cluster/main-dev-us-west-1-cluste"
}

variable "app_image" {
    type = string
    default = "nginx:latest"
}

variable "app_port" {
    type = string
    default = 8080
}

variable "fargate_cpu" {
    type = string
    default = "1024"
}

variable "fargate_memory" {
    type = string
    default = "2048"
}

variable "health_check_path" {
    type = string
    default = "/"
}
