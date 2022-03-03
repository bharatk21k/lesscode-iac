terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.74.0"
    }
  }
}

provider "aws" {
  profile                 = "var.env"
  shared_credentials_file = "$HOME/.aws/credentials"
  region                  = var.region
}

data "aws_vpc" "vpc" {
  tags = {
    Name = var.cluster_name
  }
}
data "aws_route53_zone" "opensearch" {
  name = var.cluster_domain
}
#data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_availability_zones" "available" {}
