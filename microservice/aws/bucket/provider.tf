
# provider.tf

# Specify the provider and access details
provider "aws" {
  profile                 = va.env
  region                  = var.region
}