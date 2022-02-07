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
    default = "test"
}

variable "dlq"{
    type= bool
    default = false
}

variable "dlq_arn"{
    type= string
    default = "arn:aws:sqs:us-west-2:092166348842:dev-dlq"
}

variable "dlq_max_reeceive_count" {
    default = 4
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



