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

locals {
  tags = {
    name = var.prefix
    env  = var.env
  }
}

module "vpc" {
  count                = var.enabled ? 1 : 0
  source               = "./vpc"
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  availability_zones   = ["us-west-2a", "us-west-2b"]
  public_subnets       = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnets      = ["10.0.2.0/24", "10.0.3.0/24"]
  tags                 = local.tags
}

module "nat_gateway" {
  count              = var.enabled ? 1 : 0
  source             = "./nat_gateway"
  public_subnet_ids  = module.vpc.public_subnet_ids[0]
  private_subnet_ids = module.vpc.private_subnet_ids[0]
  tags               = local.tags
}