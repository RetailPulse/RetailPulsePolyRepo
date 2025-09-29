# Trust policy for the controller SA
data "aws_iam_policy_document" "alb_trust" {
  statement {
    effect = "Allow"
    principals {
        type = "Federated"
        identifiers = [var.oidc_provider_arn]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }
  }
}

resource "aws_iam_role" "alb_controller" {
  name               = "${var.name_prefix}-alb-controller"
  assume_role_policy = data.aws_iam_policy_document.alb_trust.json
}

data "aws_iam_policy_document" "alb_controller" {
  statement {
    effect = "Allow"
    actions = [
      "iam:CreateServiceLinkedRole",
      "ec2:CreateSecurityGroup",
      "ec2:DeleteSecurityGroup",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:CreateTags",
      "ec2:DeleteTags",
      "ec2:Describe*",
      "elasticloadbalancing:*",
      "cognito-idp:DescribeUserPoolClient",
      "waf-regional:*",
      "wafv2:*",
      "shield:CreateProtection",
      "shield:DeleteProtection",
      "shield:DescribeProtection",
      "shield:GetSubscriptionState",
      "shield:ListProtections"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "alb_controller" {
  name   = "${var.name_prefix}-alb-controller-policy"
  policy = data.aws_iam_policy_document.alb_controller.json
}

resource "aws_iam_role_policy_attachment" "alb_controller_attach" {
  role       = aws_iam_role.alb_controller.name
  policy_arn = aws_iam_policy.alb_controller.arn
}