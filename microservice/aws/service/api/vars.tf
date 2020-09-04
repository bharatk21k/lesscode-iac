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
  default = "vpc-0c1aad88a9d302cf8"
}

variable "ecs_cluster_name" {
    type = string
    default = "main-dev-us-west-1-load-balancer-2104505543.us-east-1.elb.amazonaws.com"
}

variable "aws_security_group_lb_id" {
  default ="sg-07c3c2059b7f4b4e7"
}

variable "aws_alb_listener_arn" {
    type = string
    default = "arn:aws:elasticloadbalancing:us-east-1:284832936816:listener/app/main-dev-us-west-1-load-balancer/8ea98e2ffd48c3dc/a6b1a3bdfcf66899"
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

variable "path" {
    type = string
    default = "/"
}

variable "health_check_path" {
    type = string
    default = "/"
}
