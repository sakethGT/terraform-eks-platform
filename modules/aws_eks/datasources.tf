# datasources

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_availability_zones" "azs" {}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.vpc.id

  filter {
    name   = "tag:type"
    values = ["private"]
  }
}
