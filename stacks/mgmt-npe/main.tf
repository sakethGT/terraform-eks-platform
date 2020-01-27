locals {
  vpc_id                    = "vpc-01303c8b1358d0199"
  region                    = "us-east-1"
  stack                     = "mgmt"
  env                       = "npe"
  role_admin                = "SREAdminRole"
  asg_min_size              = "6"
  asg_desired_capacity      = "6"

  env_tags = "${map(
    "stack", "mgmt",
    "env", "npe",
    "CustomerID", "9600",
    "CustomerName", "Product Development",
    "EnvironmentType", "INTERNAL-DEV",
    "ProductLine", "RMS-ONE",
    "ProductSKU", "RMS-ONE-NI",
    "ProjectCode", "",
    "RequestID", ""
  )}"
}

# NOTE can't use vars in backend
terraform {
  required_version = "= 0.11.14"

  backend "s3" {
    bucket = "rms-platform-terraform-state-npe"
    key    = "mgmt-npe-us-east-1/terraform.state"
    region = "us-east-1"
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
}
