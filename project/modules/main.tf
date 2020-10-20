terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = var.region
}

locals {
  tags = {
    name = var.prefix
    env  = var.env
  }
}

module "iam" {
  source              = "./iam"
  tags                = var.tags
  dunamodb_table_name = var.dynamodb_table_name
}

module "vpc" {
  count                = var.enabled ? 1 : 0
  source               = "./vpc"
  region               = var.region
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  availability_zones   = ["us-west-2a", "us-west-2b"]
  public_subnets       = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnets      = ["10.0.2.0/24", "10.0.3.0/24"]
  tags                 = local.tags
}