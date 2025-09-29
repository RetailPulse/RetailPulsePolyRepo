variable "name_prefix" { type = string }  # passed from parent
variable "project"     { type = string }
variable "env"         { type = string }

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.name_prefix}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-southeast-1a","ap-southeast-1b","ap-southeast-1c"]
  public_subnets  = ["10.0.0.0/20","10.0.16.0/20","10.0.32.0/20"]
  private_subnets = ["10.0.64.0/20","10.0.80.0/20","10.0.96.0/20"]        # app
  database_subnets= ["10.0.128.0/20","10.0.144.0/20","10.0.160.0/20"]     # db

  public_subnet_tags = {
    "kubernetes.io/role/elb"                         = 1
    "kubernetes.io/cluster/${var.name_prefix}-eks"   = "shared"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"                = 1
    "kubernetes.io/cluster/${var.name_prefix}-eks"   = "shared"
  }

  enable_nat_gateway  = true
  single_nat_gateway  = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  create_database_subnet_group = true

  tags = { Name = "${var.name_prefix}-vpc", Project = var.project, Env = var.env }
}

module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "~> 5.0"

  vpc_id = module.vpc.vpc_id

  endpoints = {
    s3 = {
      service          = "s3"
      service_type     = "Gateway"
      route_table_ids  = module.vpc.private_route_table_ids
      tags             = { Name = "${var.name_prefix}-s3-endpoint" }
    }
    dynamodb = {
      service          = "dynamodb"
      service_type     = "Gateway"
      route_table_ids  = module.vpc.private_route_table_ids
      tags             = { Name = "${var.name_prefix}-dynamodb-endpoint" }
    }
  }

  tags = { Project = var.project, Env = var.env }
}

resource "aws_security_group" "eks_nodes" {
  name        = "${var.name_prefix}-sg-eks-nodes"
  description = "EKS worker nodes"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group" "alb" {
  name        = "${var.name_prefix}-sg-alb"
  description = "Public ALB"
  vpc_id      = module.vpc.vpc_id
}