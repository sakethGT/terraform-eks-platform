# IAM role for workflow services using IRSA pattern
data "aws_iam_policy_document" "workflow" {
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

resource "aws_iam_role" "workflow" {
  name               = "k8s-workflow-${var.stack}-${var.env}"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.workflow.json
}

data "aws_iam_policy_document" "workflow-policy" {
  statement {
    sid    = "list"
    effect = "Allow"

    actions = [
      "rds:*",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "workflow" {
  name   = "workflow-${var.stack}-${var.env}"
  role   = aws_iam_role.workflow.id
  policy = data.aws_iam_policy_document.workflow-policy.json
}
