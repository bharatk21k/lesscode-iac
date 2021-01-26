# variables
variable "region" {
    type = string
}

variable "domain" {
    type = string
    default = "main.dev.vethospital.io"
}

variable "zoneid" {
    type = string
}

variable "env" {
    type = string
}

vatiable "vpc_id" {
    type= string
}

variable "ecs_cluster_name" {
    type = string
}

variable "az_count" {
    default = 2
}

variable "tls_port" {
  description = "LB port"
  default     = 443
}
