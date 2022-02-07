# variables
variable "region" {
    type = string
    default ="us-west-2"
}

variable "env" {
    type = string
    default ="dev"
}

variable "ecs_cluster_name" {
    type = string
    default ="dev"
}

variable "name" {
    type = string
    default = "dlq"
}

variable "delay_seconds" {
    default = 0
}

variable "max_message_size" {
    default = 262144
}

# 30 days
variable "message_retention_seconds" {
    default = 1209600
}



