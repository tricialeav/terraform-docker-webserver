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

data "aws_caller_identity" "current" {}

module "iam" {
  count               = var.enabled ? 1 : 0
  source              = "./iam"
  tags                = local.tags
  dynamodb_table_name = join("-", [var.dynamodb_table_name, var.env])
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

module "ecs" {
  count           = var.enabled ? 1 : 0
  source          = "./ecs"
  region          = var.region
  tags            = local.tags
  env             = var.env
  vpc_id          = module.vpc.vpc_id
  vpc_cidr        = module.vpc.vpc_cidr
  container_image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.us-west-2.amazonaws.com/web-app:${var.image_tag}"
  container_name  = "web-app"
  port_mappings = [
    {
      "containerPort" : 8080,
      "hostPort" : 8080,
      "protocol" : "http"
    }
  ]
  log_driver = "awslogs"
  essential  = "true"
}