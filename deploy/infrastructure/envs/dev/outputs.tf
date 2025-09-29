# Bubble up VPC + subnets from the network module
output "vpc_id" {
  description = "VPC ID"
  value       = module.network.vpc_id
}

output "public_subnets" {
  description = "Public subnet IDs"
  value       = module.network.public_subnets
}

output "private_subnets" {
  description = "Private (app) subnet IDs"
  value       = module.network.private_app_subnets
}

output "database_subnets" {
  description = "DB subnet IDs"
  value       = module.network.database_subnets
}

# (handy when scripting)
output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks_stack.cluster_name
}