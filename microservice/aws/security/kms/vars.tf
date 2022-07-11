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
    default ="us-east-2"
}

variable "replica2_region" {
    type = string
    default ="us-west-1"
}

variable "tenant_id" {
    type = string
    default = "TEN1"
}

variable "key" {
    type = string
    default = "ssfG5HJlTO5VG2Vi1gtZLRsX8rvEG89TYSaVDbgIXLQ="
}

variable "ecs_cluster_name" {
    type = string
     default = "dev"
}



