
# provider.tf

# Specify the provider and access details
provider "aws" {
  shared_credentials_files = ["/Users/me/.aws/credentials"]
  profile                 = "default"
  region                  = var.region
}