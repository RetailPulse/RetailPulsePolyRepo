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

# EKS security groups (bubble up from module.eks_stack)
output "node_security_group_id" {
  description = "Security Group used by EKS managed node groups"
  value       = module.eks_stack.node_security_group_id
}

output "cluster_security_group_id" {
  description = "EKS cluster security group (control plane managed)"
  value       = module.eks_stack.cluster_security_group_id
}

# RDS
output "auth_mysql_endpoint" { value = module.mysql.auth_endpoint }
output "core_mysql_endpoint" { value = module.mysql.core_endpoint }
output "mysql_sg_id" { value = module.mysql.mysql_sg_id }
output "auth_admin_secret_arn" { value = module.mysql.auth_admin_secret_arn }
output "core_admin_secret_arn" { value = module.mysql.core_admin_secret_arn }

# DocDB
output "docdb_cluster_endpoint" {
    value = module.docdb.docdb_cluster_endpoint
}
output "cluster_ca_certificate" {
  description = "Cluster CA data (base64)"
  value       = module.eks_stack.cluster_ca_certificate
}
output "docdb_reader_endpoint" {
    value = module.docdb.docdb_reader_endpoint
}
output "docdb_sg_id" {
    value = module.docdb.docdb_sg_id
}
output "docdb_admin_secret_arn" {
    value = module.docdb.docdb_admin_secret_arn
}