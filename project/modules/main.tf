terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    region         = var.region
    bucket         = var.backend_state_bucket
    key            = "deployments/environments/${var.env}/project/terraform.tfstate"
    dynamodb_table = var.dynamo_state_lock
    encrypt        = true
  }
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