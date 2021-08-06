# variables
variable "region" {
    type = string
}

variable "name" {
    type = string
}

variable "env" {
    type = string
}

variable "ecs_cluster_name" {
    type = string
}

variable "billing_mode" {
    type = string
    default = "PAY_PER_REQUEST"
}

variable "hash_key" {
    type = string
    default="PK"
}

variable "range_key" {
    type = string
    default = "SK"
}

variable "gsis" {
  type = list(object({
    name               = string
    hash_key           = string
    range_key          = string
    projection_type    = string
  }))
} 

