output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS API server endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_ca_certificate" {
  description = "Base64-encoded cluster CA for kubectl"
  value       = module.eks.cluster_certificate_authority_data
}

output "oidc_provider_arn" {
  description = "OIDC provider ARN used by IRSA"
  value       = module.eks.oidc_provider_arn
}

output "node_group_names" {
  description = "Managed node group names"
  value       = keys(module.eks.eks_managed_node_groups)
}

output "cluster_oidc_issuer_url" {
  description = "Cluster OIDC issuer URL"
  value       = module.eks.cluster_oidc_issuer_url
}

output "node_security_group_id" {
  description = "Security Group used by EKS managed node groups"
  value       = module.eks.node_security_group_id
}

output "cluster_security_group_id" {
  description = "EKS cluster security group (control plane managed)"
  value       = module.eks.cluster_security_group_id
}