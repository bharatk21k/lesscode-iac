terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.74.0"
    }
  }
}

provider "aws" {
  region = var.region
  profile = "default"
  assume_role {
  role_arn = var.task_role_arn
  session_name = "${var.ecs_cluster_name}-${var.name}-${var.region}-session"
 }
}