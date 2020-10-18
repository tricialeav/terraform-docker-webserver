terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {}
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

module "vpc" {
  source     = "./vpc"
  cidr_block = "10.0.0.0/16"
  tags = {
    name = var.prefix
    env  = var.env
  }
}