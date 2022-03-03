variable "region" {
  description = "The name of the OpenSearch cluster."
  type        = string
}

variable "env" {
  description = "The name of the OpenSearch cluster."
  type        = string
}

variable "cluster_name" {
  description = "The name of the OpenSearch cluster."
  type        = string
}

variable "cluster_version" {
  description = "The version of OpenSearch to deploy."
  type        = string
}

variable "cluster_domain" {
  description = "The hosted zone name of the OpenSearch cluster."
  type        = string
}

variable "task_role_arn"{
    type = string
}

variable "create_service_role" {
  description = "Indicates whether to create the service-linked role."
  type        = bool
  default     = true
}

variable "instance_type" {
  description = "The type of EC2 instances to run for each hot node."
  type        = string
  default     = "r6g.xlarge.elasticsearch"
}

variable "instance_count" {
  description = "The number of dedicated hot nodes in the cluster."
  type        = number
  default     = 3 
}

variable "encrypt_kms_key_id" {
  description = "The KMS key ID to encrypt the OpenSearch cluster with."
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "master_instance_enabled" {
  description = "Indicates whether dedicated master nodes are enabled for the cluster."
  type        = bool
}

variable "master_instance_type" {
  description = "The type of EC2 instances to run for each master node."
  type        = string
}

variable "master_instance_count" {
  description = "The number of dedicated master nodes in the cluster."
  type        = number
}

variable "hot_instance_type" {
  description = "The type of EC2 instances to run for each hot node."
  type        = string
}

variable "hot_instance_count" {
  description = "The number of dedicated hot nodes in the cluster."
  type        = number
}

variable "warm_instance_enabled" {
  description = "Indicates whether ultrawarm nodes are enabled for the cluster."
  type        = bool
}

variable "warm_instance_type" {
  description = "The type of EC2 instances to run for each warm node."
  type        = string
}

variable "warm_instance_count" {
  description = "The number of dedicated warm nodes in the cluster."
  type        = number
}

variable "availability_zones" {
  description = "The number of availability zones for the OpenSearch cluster. Valid values: 1, 2 or 3."
  type        = number
}
