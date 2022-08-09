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

#variable "partition_name" {
 #   type = string
#}

#variable "partition_kms_arn" {
 #   type = string
#}

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

variable "GS1" {
  type = object({
    name               = string
    hash_key           = string
    range_key          = string
    projection_type    = string
  })
} 

variable "GS2" {
  type = object({
    name               = string
    hash_key           = string
    range_key          = string
    projection_type    = string
  })
} 

variable "GS3" {
  type = object({
    name               = string
    hash_key           = string
    range_key          = string
    projection_type    = string
  })
} 

variable "GS4" {
  type = object({
    name               = string
    hash_key           = string
    range_key          = string
    projection_type    = string
  })
}

variable "GS5" {
  type = object({
    name               = string
    hash_key           = string
    range_key          = string
    projection_type    = string
  })
}