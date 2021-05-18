variable "region" {
    type = string
    default = "us-west-2"
}

variable "env" {
    type = string
    default = "dev"
}

variable "ecs_cluster_name" {
    type = string
    default = "dev"
}

variable "name" {
    type = string
    default = "improvisor2"
}


variable "retention" {
    type = string
    default = "86400"
}

variable "visibility" {
    type = string
    default = "300"
}

variable "dlq" {
    type = string
    default = "arn:aws:sqs:us-west-2:092166348842:dlq-dev"
}
