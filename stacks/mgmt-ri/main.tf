locals {
  vpc_id               = "vpc-0example1234567890"
  region               = "us-east-1"
  stack                = "mgmt"
  env                  = "ri"
  role_admin           = "SREAdminRole"
  asg_max_size         = "20"
  asg_min_size         = "6"
  asg_desired_capacity = "6"
  eks_worker_type      = "m5.4xlarge"
  kubernetes_version   = "1.28"

  env_tags = {
    stack           = "mgmt"
    env             = "ri"
    terraform       = "true"
    CustomerID      = "9600"
    CustomerName    = "Product Development"
    EnvironmentType = "INTERNAL-DEV"
    ProductLine     = "PLATFORM"
    ProductSKU      = "PLATFORM-NI"
    ProjectCode     = ""
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
    key    = "mgmt-ri-us-east-1/terraform.state"
    region = "us-east-1"
  }
}

provider "aws" {
  region = local.region
}

module "eks" {
  source                    = "../../modules/aws_eks"
  stack                     = local.stack
  env                       = local.env
  env_tags                  = local.env_tags
  vpc_id                    = local.vpc_id
  role_admin                = local.role_admin
  asg_desired_capacity      = local.asg_desired_capacity
  asg_min_size              = local.asg_min_size
  asg_max_size              = local.asg_max_size
  worker_node_instance_type = local.eks_worker_type
  kubernetes_version        = local.kubernetes_version
}
