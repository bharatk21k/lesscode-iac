# provider.tf

# Specify the provider and access details
provider "aws" {
  profile                 = var.env
  region                  = var.region
}
