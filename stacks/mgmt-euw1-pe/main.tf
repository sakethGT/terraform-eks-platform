locals {
  vpc_id               = "vpc-0example1234567890"
  region               = "eu-west-1"
  stack                = "mgmt-euw1"
  env                  = "pe"
  role_admin           = "SREAdminRole"
  asg_max_size         = "20"
  asg_min_size         = "6"
  asg_desired_capacity = "6"

  env_tags = {
    stack           = "mgmt-euw1"
    env             = "pe"
    CustomerID      = "9600"
    CustomerName    = "Product Development"
    EnvironmentType = "INTERNAL-PROD"
    EnvironmentName = "Production"
    ProductLine     = "Platform"
    CostCenter      = "SBU"
    RequestID       = ""
  }
}

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }

  backend "s3" {
    bucket = "my-terraform-state"
    key    = "mgmt-pe-eu-west-1/terraform.state"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = local.region
}

module "eks" {
  source               = "../../modules/aws_eks"
  stack                = local.stack
  env                  = local.env
  env_tags             = local.env_tags
  vpc_id               = local.vpc_id
  role_admin           = local.role_admin
  asg_desired_capacity = local.asg_desired_capacity
  asg_min_size         = local.asg_min_size
  asg_max_size         = local.asg_max_size
}
