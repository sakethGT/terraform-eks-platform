data "aws_iam_policy_document" "cluster-autoscaler" {
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

resource "aws_iam_role" "cluster-autoscaler" {
  name               = "k8s-clusterautoscaler-${var.stack}-${var.env}"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.cluster-autoscaler.json}"
}

data "aws_iam_policy_document" "cluster-autoscaler-policy" {
  statement {
    sid    = "asg"
    effect = "Allow"

    actions = [
      "autoscaling:Describe*",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "cluster-autoscaler" {
  name   = "clusterautoscaler-${var.stack}-${var.env}"
  role   = "${aws_iam_role.cluster-autoscaler.id}"
  policy = "${data.aws_iam_policy_document.cluster-autoscaler-policy.json}"
}
