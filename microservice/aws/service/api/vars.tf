variable "region" {
    type = string
    default ="us-east-1"
}

variable "env" {
    type = string
    default = "dev"
}
variable "name" {
    type = string
    default = "test-api"
}

variable "vpc_id" {
  default = "vpc-0c9a14dd9316bcf9a"
}

variable "ecs_cluster_name" {
    type = string
    default = "main-dev-us-west-1"
}

variable "ecs_cluster_arn" {
    type = string
    default = "arn:aws:ecs:us-east-1:284832936816:cluster/main-dev-us-west-1-cluster"
}

variable "aws_security_group_lb_id" {
  default ="sg-0760b0162253aaa3b"
}

variable "aws_alb_listener_arn" {
    type = string
    default = "arn:aws:elasticloadbalancing:us-east-1:284832936816:listener/app/main-dev-us-west-1-load-balancer/8ca8d7f4051c5566/b67e8ef01cff5ff0"
}

variable "app_image" {
    type = string
    default = "284832936816.dkr.ecr.us-east-1.amazonaws.com/vethospital-api:589e88c587703276951e32ac7bb4b4845c5f8a50"
}

variable "app_port" {
    type = string
    default = "8090"
}

variable "app_count" {
    type = string
    default = "2"
}

variable "fargate_cpu" {
    type = string
    default = "1024"
}

variable "fargate_memory" {
    type = string
    default = "2048"
}

variable "path" {
    type = string
    default = "/"
}

variable "health_check_path" {
    type = string
    default = "/"
}

variable "subnets_privates_ids" {
    default = [
    "subnet-06b5cc64d8e16bcbf",
    "subnet-090b6d1ba1f500fba",
    ]   
}
