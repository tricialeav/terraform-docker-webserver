terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

module "remote_state_backend" {
  source    = "../modules/remote_state_backend"
  namespace = var.prefix
  stage     = var.env
}