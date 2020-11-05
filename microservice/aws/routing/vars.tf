# variables
variable "env"{
    type = string
}

variable "region" {
    type = string
    default = "us-east-1"
}

variable "zoneid" {
    type = string
}

variable "domain" {
    type = string
}

variable "alb_dns_name" {
    type = string
}


variable "continent" {
    type = string
}
