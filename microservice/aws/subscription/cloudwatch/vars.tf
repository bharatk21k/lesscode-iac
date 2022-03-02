# variables
variable "region" {
    type = string
    default = "us-west-2"
}

variable "name" {
    type = string
    default = "activity"
}

variable "env" {
    type = string
    default = "dev"
}

variable "ecs_cluster_name" {
    type = string
    default = "dev"
}

variable "service_name" {
    type = string
    default = "api-company"
}

variable "filter_pattern" {
    type = string
    default = "{$.type = \"activity\" && $.id = *}"
}

variable "task_role_arn"{
    type= string
    default = "arn:aws:iam::092166348842:role/service"
}

variable "service_arn"{
    type= string
    default = "arn:aws:lambda:us-west-2:092166348842:function:svc-dev-activity"
}
