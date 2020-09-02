# variables
variable "aws_region" {
    type = string
}

variable "zoneid" {
    type = string
}

variable "domain" {
    type = string
    default = "main.dev.vethospital.io"
}

variable "env" {
    type = string
}
