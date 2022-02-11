
# provider.tf

# Specify the provider and access details
provider "aws" {
  AWS_SHARED_CREDENTIALS_FILE = "/Users/me/.aws/credentials"
  profile                 = "default"
  region                  = var.region
}