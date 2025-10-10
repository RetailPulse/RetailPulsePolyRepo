terraform {
  required_providers {
      aws = { source  = "hashicorp/aws", version = "~> 5.60" }
      kubernetes = { source = "hashicorp/kubernetes", version = "~> 2.31" }
      helm       = { source = "hashicorp/helm",       version = "~> 2.13" }
  }
}

variable "cluster_name"            { type = string }
variable "cluster_endpoint"        { type = string }
variable "cluster_ca_certificate"  { type = string }
variable "oidc_provider_arn"       { type = string }
variable "cluster_oidc_issuer_url" { type = string }
variable "name_prefix"             { type = string }
variable "region"                  { type = string }
variable "vpc_id"                  { type = string }

# Token for talking to your EKS
data "aws_eks_cluster_auth" "this" {
  name = var.cluster_name
}

provider "kubernetes" {
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}