module "network" {
  source      = "./network"
  name_prefix = local.name_prefix
  project     = var.project
  env         = var.env
}

/* Step 2: EKS */
module "eks_stack" {
  source          = "./eks"
  vpc_id          = module.network.vpc_id
  private_subnets = module.network.private_app_subnets
  name_prefix     = local.name_prefix
  project         = var.project
  env             = var.env
  cluster_version = "1.29"
}

/* Step 3: Infra Helm */
module "helm_addons" {
  source = "./helm"
  name_prefix           = local.name_prefix
  cluster_name          = module.eks_stack.cluster_name
  cluster_endpoint      = module.eks_stack.cluster_endpoint
  cluster_ca_certificate= module.eks_stack.cluster_ca_certificate
  oidc_provider_arn     = module.eks_stack.oidc_provider_arn
  cluster_oidc_issuer_url = module.eks_stack.cluster_oidc_issuer_url
  region = var.region
  vpc_id = module.network.vpc_id
}