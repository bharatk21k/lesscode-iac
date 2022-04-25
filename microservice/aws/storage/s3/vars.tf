variable "region" {
    type = string
}

variable "env" {
    type = string
}

variable "domain" {
    type = string
}

variable "ecs_cluster_name" {
    type = string
}

variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "tags" {
  description = "Tags to assign to bucket"
}

variable "acl" {
    type = string
}

variable "allow_public" {
  type = "string"
  description = "Allow public read access to bucket"
}

variable "enable_versioning" {
  type = "string"
  description = "Conditionally enable versioning"
}

variable "enable_default_server_side_encryption" {
  type = "string"
  description = "Conditionally enable server side encryption by default"
}
