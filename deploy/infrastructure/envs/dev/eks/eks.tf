module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${var.name_prefix}-eks"
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  # Enable OIDC provider so we can use IRSA (IAM Roles for Service Accounts)
  enable_irsa = true

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  cluster_endpoint_public_access_cidrs = [
    "0.0.0.0/0" # TODO: tighten to your IP/CIDR before prod  # for quick testing; tighten to your IP when confirmed; "YOUR.PUBLIC.IP.ADDR/32"
  ]

  authentication_mode = "API_AND_CONFIG_MAP"  # optional but helpful

  # Two managed node groups: on-demand (critical/system) and spot (stateless)
  eks_managed_node_groups = {
    general_ondemand = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.large"]
      capacity_type  = "ON_DEMAND"

      desired_size   = 3
      min_size       = 2
      max_size       = 6

      labels         = { pool = "general" }
      tags           = { Name = "${var.name_prefix}-general" }
    }

    workload_spot = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.large","m5.large"]  # a mix improves Spot availability
      capacity_type  = "SPOT"

      desired_size   = 3
      min_size       = 1
      max_size       = 9

      labels         = { pool = "spot" }
      tags           = { Name = "${var.name_prefix}-spot" }
    }
  }

  tags = {
    Project = var.project
    Env     = var.env
    IaC     = "opentofu"
  }

  # Map your IAM user to cluster-admin
  access_entries = {
    galvin_admin = {
      principal_arn = "arn:aws:iam::051826728851:user/Galvin_MTech_IAMUser_Admin"
      policy_associations = [{
        policy_arn  = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
        access_scope = { type = "cluster" }
      }]
    },
    retailpulse_admin = {
      principal_arn = "arn:aws:iam::051826728851:user/RetailPulse"

      policy_associations = [
        {
          policy_arn  = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        },
        {
          policy_arn  = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      ]
    }
  }
}