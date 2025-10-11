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
