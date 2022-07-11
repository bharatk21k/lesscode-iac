terraform {
  required_providers {
    pingdom   = {
      source  = "nordcloud/pingdom"
      version = "1.1.4"
    }
  }
}

provider "aws" {
  profile   = var.env
  region    = var.region
}

provider "pingdom" {
  api_token = var.pingdom_api_token
}
