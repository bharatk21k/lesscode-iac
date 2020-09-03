# variables
variable "region" {
    type = string
}

variable "domain" {
    type = string
    default = "main.dev.vethospital.io"
}

variable "env" {
    type = string
}

variable "ecs_cluster_name" {
    type = string
}

variable "acm_certificate" {
    type = string
}

variable "az_count" {
    default = 2
}

variable "tls_port" {
  description = "LB port"
  default     = 443
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 8080
}
