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