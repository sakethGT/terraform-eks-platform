locals {
  tags = "${merge(
    var.env_tags,
    map(
      "Name", "${var.stack}-${var.env}",
    )
  )}"

  worker_groups = [
    {
      instance_type        = "${var.worker_node_instance_type}"
      key_name             = "${var.stack}.${var.env}.key"
      iam_role_id          = "${aws_iam_role.eks.id}"
      subnets              = "${join(",", data.aws_subnet_ids.private.ids)}"
      asg_desired_capacity = "${var.asg_desired_capacity}"
      asg_min_size         = "${var.asg_min_size}"
      asg_max_size         = "${var.asg_max_size}"
      autoscaling_enabled  = 1
    },
  ]

  workers_group_defaults {
    root_volume_size = "${var.root_volume_size}"
  }

  map_roles = [
    {
      role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.role_admin}"
      username = "k8s_admins"
      group    = "system:masters"
    },
  ]
}

resource "aws_security_group" "eks_worker_sg_cust" {
  name        = "${var.stack}-${var.env}-eks_worker_sg"
  description = "Security group for all nodes in the cluster."
  vpc_id      = "${data.aws_vpc.vpc.id}"

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
  source                               = "github.com/terraform-aws-modules/terraform-aws-eks?ref=v2.3.1"
  cluster_version                      = "${var.kubernetes_version}"
  cluster_name                         = "${var.stack}-${var.env}"
  subnets                              = "${data.aws_subnet_ids.private.ids}"
  tags                                 = "${local.tags}"
  vpc_id                               = "${data.aws_vpc.vpc.id}"
  worker_groups                        = "${local.worker_groups}"
  worker_group_count                   = "1"
  map_roles                            = "${local.map_roles}"
  map_roles_count                      = "1"
  workers_group_defaults               = "${local.workers_group_defaults}"
  worker_additional_security_group_ids = ["${aws_security_group.eks_worker_sg_cust.id}"]
}
