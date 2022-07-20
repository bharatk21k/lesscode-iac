# variables
variable "region" {
    type = string
    default ="us-west-2"
}

variable "env" {
    type = string
    default ="dev"
}

variable "replica1_region" {
    type = string
    default ="eu-west-1"
}

variable "replica2_region" {
    type = string
    default ="ap-southeast-1"
}

variable "partition_name" {
    type = string
    default = "TEN1"
}






