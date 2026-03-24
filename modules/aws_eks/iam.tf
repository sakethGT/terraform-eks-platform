locals {
  eks_policies = [
    "AmazonEKSWorkerNodePolicy",
    "AmazonEC2ContainerRegistryReadOnly",
    "AmazonEKS_CNI_Policy",
  ]
}

data "aws_iam_policy_document" "eks" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks" {
  name               = "EKSWorker-${var.stack}-${var.env}"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.eks.json
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSClusterPolicy" {
  count      = length(local.eks_policies)
  policy_arn = "arn:aws:iam::aws:policy/${element(local.eks_policies, count.index)}"
  role       = aws_iam_role.eks.name
}

# IRSA-compatible STS policy for pod-level IAM access
data "aws_iam_policy_document" "eks-sts" {
  statement {
    sid    = "irsasts"
    effect = "Allow"

    actions = [
      "sts:AssumeRole*",
    ]

    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*"]
  }
}

resource "aws_iam_role_policy" "eks-sts" {
  name   = "irsa-sts-${var.stack}-${var.env}"
  role   = aws_iam_role.eks.id
  policy = data.aws_iam_policy_document.eks-sts.json
}
