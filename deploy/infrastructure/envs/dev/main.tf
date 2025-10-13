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
  cluster_version = "1.34"
}

/* Step 3: Infra Helm */
module "helm_addons" {
  source = "./helm"

  cluster_name            = module.eks_stack.cluster_name
  cluster_endpoint        = module.eks_stack.cluster_endpoint
  cluster_ca_certificate  = module.eks_stack.cluster_ca_certificate
  oidc_provider_arn       = module.eks_stack.oidc_provider_arn
  cluster_oidc_issuer_url = module.eks_stack.cluster_oidc_issuer_url
  name_prefix             = local.name_prefix
  region                  = var.region
  vpc_id                  = module.network.vpc_id

  providers = {
    helm       = helm
    kubernetes = kubernetes
  }

  depends_on = [module.eks_stack]
}

/* Step 4a: MySQL  */
module "mysql" {
  source           = "./db/mysql"
  name_prefix      = local.name_prefix
  vpc_id           = module.network.vpc_id
  database_subnets = module.network.database_subnets
  eks_node_sg_id   = module.eks_stack.node_security_group_id

  # optional overrides:
  # instance_class     = "db.t4g.medium"
  # multi_az           = true
}

/* Step 4b: DocumentDB  */
module "docdb" {
  source           = "./db/docdb"
  name_prefix      = local.name_prefix
  vpc_id           = module.network.vpc_id
  database_subnets = module.network.database_subnets
  eks_node_sg_id   = module.eks_stack.node_security_group_id
  # instances = 2
}

/* Step 4c: Secret Store */
module "k8s" {
  source = "./k8s"

  region           = var.region
  name_prefix      = local.name_prefix
  sample_namespace = "sample"

  providers = {
    kubernetes = kubernetes
  }

  # Wait for Helm add-ons (External Secrets CRDs, etc.)
  depends_on = [ module.helm_addons ]
}

/* Step 5: Setup API Gateway */
module "api_gateway" {
  source = "./api-gateway"

  name_prefix        = "retailpulse"
  project            = "retailpulse"
  env                = "dev"

  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_app_subnets
  alb_sg_id          = module.network.alb_sg_id

  services = [
    {
      name         = "iam"
      path_prefix  = "/auth"
      listener_arn = "arn:aws:elasticloadbalancing:ap-southeast-1:051826728851:listener/app/k8s-retailpulseapi-8cb0989ca5/0cfdd45244a40e2a/153863d6f4470788"
    },
    {
      name         = "user"
      path_prefix  = "/user"
      listener_arn = "arn:aws:elasticloadbalancing:ap-southeast-1:051826728851:listener/app/k8s-retailpulseapi-8cb0989ca5/0cfdd45244a40e2a/153863d6f4470788"
    },
    {
      name         = "inventory"
      path_prefix  = "/inventory"
      listener_arn = "arn:aws:elasticloadbalancing:ap-southeast-1:051826728851:listener/app/k8s-retailpulseapi-8cb0989ca5/0cfdd45244a40e2a/153863d6f4470788"
    }
  ]
}

