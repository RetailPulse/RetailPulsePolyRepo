output "auth_endpoint" { value = aws_db_instance.auth.address }
output "core_endpoint" { value = aws_db_instance.core.address }
output "mysql_sg_id"   { value = aws_security_group.mysql.id }

output "auth_admin_secret_arn" { value = aws_secretsmanager_secret.auth_admin.arn }
output "core_admin_secret_arn" { value = aws_secretsmanager_secret.core_admin.arn }