resource "aws_iam_role" "eso" {
  name = "${var.name_prefix}-eso-irsa"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Federated = var.oidc_provider_arn },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "${replace(var.cluster_oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:externalsecrets:external-secrets"
        }
      }
    }]
  })
}

data "aws_iam_policy_document" "eso" {
  statement {
    actions   = ["secretsmanager:GetSecretValue","secretsmanager:DescribeSecret","secretsmanager:ListSecretVersionIds"]
    resources = [
      "arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:secret:${var.name_prefix}/db/*"
    ]
  }
}
resource "aws_iam_policy" "eso" {
  name   = "${var.name_prefix}-eso-policy"
  policy = data.aws_iam_policy_document.eso.json
}
resource "aws_iam_role_policy_attachment" "eso_attach" {
  role       = aws_iam_role.eso.name
  policy_arn = aws_iam_policy.eso.arn
}

resource "helm_release" "external_secrets" {
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  version    = "0.10.5"
  namespace  = "externalsecrets"
  create_namespace = true

  wait    = true
  timeout = 900
  atomic  = true

  # Ensure ALB Controller (and its webhook) are READY before installing ESO
  depends_on = [
      helm_release.aws_load_balancer_controller
  ]

  values = [yamlencode({
    installCRDs= true
    serviceAccount = {
      create = true
      name   = "external-secrets"
      annotations = {
        "eks.amazonaws.com/role-arn" = aws_iam_role.eso.arn
      }
    }
  })]
}

data "aws_caller_identity" "current" {}