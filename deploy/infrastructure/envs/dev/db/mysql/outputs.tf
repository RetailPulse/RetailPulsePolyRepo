output "auth_endpoint" { value = aws_db_instance.auth.address }
output "core_endpoint" { value = aws_db_instance.core.address }
output "mysql_sg_id"   { value = aws_security_group.mysql.id }

output "auth_admin_secret_arn" { value = aws_secretsmanager_secret.auth_admin.arn }
output "core_admin_secret_arn" { value = aws_secretsmanager_secret.be_admin.arn }


output "auth_admin_password" {
  value     = random_password.auth_admin.result
  sensitive = true
}

output "core_admin_password" {
  value     = random_password.core_admin.result
  sensitive = true
}

output "auth_db_name" {
  value = local.auth_db_name
}

output "be_db_name" {
  value = local.be_db_name
}

output "inventory_db_name" {
  value = local.inventory_db_name
}

output "sales_db_name" {
  value = local.sales_db_name
}

output "payment_db_name" {
  value = local.payment_db_name
}