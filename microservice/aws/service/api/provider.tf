
# provider.tf

# Specify the provider and access details
provider "aws" {
  shared_credentials_files = "$HOME/.aws/credentials"
  profile                 = var.env
  region                  = var.region
}
