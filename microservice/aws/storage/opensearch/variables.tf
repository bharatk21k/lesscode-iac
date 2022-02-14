variable "tags" {
  type = map
  default = {}
}

variable "env" {
    type = string
    default = "dev"
}

variable "region" {
    type = string
    default = "us-west-2"
}

variable "name" {
    type = string
}

variable "ecs_cluster_name" {
    type = string
}

variable "sub_tag" {
    type = string
  default = "dev"
}

variable "task_role_arn"{
    type = string
    default ="arn:aws:iam::092166348842:role/service"
}

variable "opensearch_version" {
  type = string
}

variable "data_instance_count" {
  type = number
  default = "4"
}

variable "data_instance_type" {
  type = string
}

variable "data_instance_storage" {
  type = number
  default = "25"
}

variable "dedicated_master_enabled" {
  type = string
  default = "true"
}

variable "master_instance_type" {
  type = string
  default = "r4.xlarge.elasticsearch"
}

variable "user_name" {
    type = string
  default = "admin"
}

variable "user_password" {
    type = string
  default = "Admin@1231!"
}

variable "encrypt_at_rest" {
  type = bool
  default = true
  description = "Default is 'true'. Can be disabled for unsupported instance types."
}

variable "zone_awareness_enabled" {
  type = bool
  default = true
}

variable "availability_zones" {
  description = "The number of availability zones for the OpenSearch cluster. Valid values: 1, 2 or 3."
  type        = number
  default     = 2
}
