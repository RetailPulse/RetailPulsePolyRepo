module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${var.name_prefix}-eks"
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  enable_irsa = true  # OIDC provider for IRSA

  eks_managed_node_groups = {
    general_ondemand = {
      ami_type       = "AL2_ARM_64"
      instance_types = ["m6g.large"]
      capacity_type  = "ON_DEMAND"
      desired_size   = 3
      min_size       = 2
      max_size       = 6
      labels         = { pool = "general" }
      tags           = { Name = "${var.name_prefix}-general" }
    }

    workload_spot = {
      ami_type       = "AL2_ARM_64"
      instance_types = ["m6g.large", "m6g.xlarge"] # diversity helps spot availability
      capacity_type  = "SPOT"
      desired_size   = 2
      min_size       = 1
      max_size       = 10
      labels         = { pool = "spot" }
      tags           = { Name = "${var.name_prefix}-spot" }
    }
  }

  tags = {
    Project = var.project
    Env     = var.env
    IaC     = "opentofu"
  }
}