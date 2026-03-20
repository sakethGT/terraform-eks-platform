# IAM role for external-dns using IRSA pattern
data "aws_iam_policy_document" "external-dns" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/EKSWorker-${var.stack}-${var.env}"]
    }
  }
}

resource "aws_iam_role" "external-dns" {
  name               = "k8s-external-dns-${var.stack}-${var.env}"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.external-dns.json
}

data "aws_iam_policy_document" "external-dns-policy" {
  statement {
    sid    = "list"
    effect = "Allow"

    actions = [
      "route53:List*",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "edit"
    effect = "Allow"

    actions = [
      "route53:ChangeResourceRecordSets",
    ]

    resources = [
      "arn:aws:route53:::hostedzone/*",
    ]
  }
}

resource "aws_iam_role_policy" "external-dns" {
  name   = "external-dns-${var.stack}-${var.env}"
  role   = aws_iam_role.external-dns.id
  policy = data.aws_iam_policy_document.external-dns-policy.json
}
