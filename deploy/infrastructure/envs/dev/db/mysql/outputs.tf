#############################################
# Aurora MySQL Outputs
#############################################

# Cluster endpoints (writers)
output "auth_endpoint" {
  description = "Writer endpoint for the auth Aurora cluster"
  value       = aws_rds_cluster.auth.endpoint
}

output "core_endpoint" {
  description = "Writer endpoint for the core Aurora cluster"
  value       = aws_rds_cluster.core.endpoint
}

# Reader endpoints (load-balanced across 2 readers)
output "auth_reader_endpoint" {
  description = "Reader endpoint for auth Aurora cluster"
  value       = aws_rds_cluster.auth.reader_endpoint
}

output "core_reader_endpoint" {
  description = "Reader endpoint for core Aurora cluster"
  value       = aws_rds_cluster.core.reader_endpoint
}

# Security group ID for database connectivity
output "mysql_sg_id" {
  description = "Security group ID used by Aurora MySQL clusters"
  value       = aws_security_group.mysql.id
}

#############################################
# Secrets Manager Outputs
#############################################
output "auth_admin_secret_arn" {
  description = "ARN for auth DB admin secret"
  value       = aws_secretsmanager_secret.auth_admin.arn
}

output "core_admin_secret_arn" {
  description = "ARN for core DB admin secret"
  value       = aws_secretsmanager_secret.be_admin.arn
}

#############################################
# Credentials and Schema Names
#############################################
output "auth_admin_password" {
  description = "Generated admin password for auth cluster"
  value       = random_password.auth_admin.result
  sensitive   = true
}

output "core_admin_password" {
  description = "Generated admin password for core cluster"
  value       = random_password.core_admin.result
  sensitive   = true
}

# Logical database/schema names
output "auth_db_name"      { value = local.auth_db_name }
output "be_db_name"        { value = local.be_db_name }
output "inventory_db_name" { value = local.inventory_db_name }
output "sales_db_name"     { value = local.sales_db_name }
output "payment_db_name"   { value = local.payment_db_name }
