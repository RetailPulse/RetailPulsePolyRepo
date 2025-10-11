resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.10.0"

  namespace        = "kube-system"
  create_namespace = false

    wait    = true
    timeout = 900  # 15m; cluster may need time to pull images/webhooks

    # (Optional but nice) make chart installs atomic
    atomic = true

  set {
      name = "clusterName"
      value = var.cluster_name
  }
  set {
      name = "region"
      value = var.region
  }
  set {
      name = "vpcId"
      value = var.vpc_id
  }

  # IRSA wiring
  set {
      name = "serviceAccount.create"
      value = "true"
  }
  set {
      name = "serviceAccount.name"
      value = "aws-load-balancer-controller"
  }
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.alb_controller.arn
  }

  depends_on = [
    aws_iam_role_policy_attachment.alb_controller_attach
  ]
}