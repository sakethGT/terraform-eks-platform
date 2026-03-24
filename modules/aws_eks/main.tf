locals {
  tags = merge(
    var.env_tags,
    {
      Name = "${var.stack}-${var.env}"
    }
  )

}

resource "aws_security_group" "eks_worker_sg_cust" {
  name        = "${var.stack}-${var.env}-eks_worker_sg"
  description = "Security group for all nodes in the cluster."
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  tags = {
    Name = "${var.stack}-${var.env}-eks_worker_sg"
  }
}

module "eks" {
  source                               = "terraform-aws-modules/eks/aws"
  version                              = "~> 19.0"
  cluster_version                      = var.kubernetes_version
  cluster_name                         = "${var.stack}-${var.env}"
  subnet_ids                           = data.aws_subnets.private.ids
  tags                                 = local.tags
  vpc_id                               = data.aws_vpc.vpc.id
  eks_managed_node_groups = {
    default = {
      instance_types       = [var.worker_node_instance_type]
      desired_size         = var.asg_desired_capacity
      min_size             = var.asg_min_size
      max_size             = var.asg_max_size
      iam_role_arn         = aws_iam_role.eks.arn
      key_name             = "${var.stack}.${var.env}.key"
    }
  }
  cluster_additional_security_group_ids = [aws_security_group.eks_worker_sg_cust.id]
}
