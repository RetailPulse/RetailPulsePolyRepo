# dev/providers_k8s.tf
provider "kubernetes" {
  host                   = module.eks_stack.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_stack.cluster_ca_certificate)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks", "get-token",
      "--region", var.region,
      "--cluster-name", module.eks_stack.cluster_name
    ]
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks_stack.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_stack.cluster_ca_certificate)

    exec {
      api_version = "client.authentication.k8s.io/v1"
      command     = "aws"
      args = [
        "eks", "get-token",
        "--region", var.region,
        "--cluster-name", module.eks_stack.cluster_name
      ]
    }
  }
}