variable "region" {
    type = string
}

variable "env" {
    type = string
}

variable "domain" {
    type = string
}

variable "ecs_cluster_name" {
    type = string
}

variable "service_name" {
    type = string
}

variable "name" {
    type = string
    #default = "test-api"
}

variable "tls_port" {
  description = "LB port"
  default     = 443
}

variable "service_image" {
    type = string
    #default = "284832936816.dkr.ecr.us-east-1.amazonaws.com/vethospital-api:1cc4f28e15fede7647db2ce5177f93fe1ef32e49"
}

variable "service_port" {
    type = string
    #default = "8090"
}

variable "service_count_min" {
    type = string
    default = "2"
}

variable "service_count_max" {
    type = string
    default = "6"
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
    #default = "/api"
}

variable "health_check_path" {
    type = string
    #default = "/api/v1/tennants/123"
}

variable "dependencies" {
    type = list
    default =[]
}

variable "metrics_count" {
    type = list
    default =["2","3","4","5"]
}

variable "metrics_p95" {
    type = list
    default =["2"]
}

variable "task_role_arn"{
    type= string
}

variable "priority" {
    default = 99
}

variable "efs_id" {
    type = string
}

variable "log_retention" {
    description = "cloud watch log retention in days. 0 mean never expire"
    default = 0
}
