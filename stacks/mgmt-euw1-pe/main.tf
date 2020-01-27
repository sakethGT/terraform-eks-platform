locals {
  vpc_id                    = "vpc-007c7733e59dae605"
  region                    = "eu-west-1"
  stack                     = "mgmt-euw1"
  env                       = "pe"
  role_admin                = "SREAdminRole"
  asg_max_size              = "20"
  asg_min_size              = "6"
  asg_desired_capacity      = "6"

  env_tags = "${map(
    "stack", "mgmt-euw1",
    "env", "pe",
    "CustomerID", "9600",
    "CustomerName", "Product Development",
    "EnvironmentType", "INTERNAL-PROD",
    "EnvironmentName", "Production",
    "ProductLine", "LIaaS",
    "CostCenter", "SBU",
    "RequestID", ""
  )}"
}

# NOTE can't use vars in backend
terraform {
  required_version = "= 0.11.14"

  backend "s3" {
    bucket = "pe-terraform-state-files"
    key    = "mgmt-pe-eu-west-1/terraform.state"
    region = "eu-west-1"
  }
}

provider "aws" {
  region  = "${local.region}"
  version = "~> 2.11.0"
}

module "eks" {
  source                    = "../../modules/aws_eks"
  stack                     = "${local.stack}"
  env                       = "${local.env}"
  env_tags                  = "${local.env_tags}"
  vpc_id                    = "${local.vpc_id}"
  role_admin                = "${local.role_admin}"
  asg_desired_capacity      = "${local.asg_desired_capacity}"
  asg_min_size              = "${local.asg_min_size}"
  asg_max_size              = "${local.asg_max_size}"
}
