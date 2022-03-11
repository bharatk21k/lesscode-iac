terraform {
  required_providers {
    pingdom = {
      source = "russellcardullo/pingdom"
      version = "1.1.3"
    }
  }
}

provider "aws" {
  profile                 = var.env
  region                  = var.region
}

provider "pingdom" {
    api_token = "${var.pingdom_api_token}"
}
