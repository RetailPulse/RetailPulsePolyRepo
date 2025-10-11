output "docdb_cluster_endpoint" { value = aws_docdb_cluster.this.endpoint }
output "docdb_reader_endpoint"  { value = aws_docdb_cluster.this.reader_endpoint }
output "docdb_sg_id"            { value = aws_security_group.docdb.id }
output "docdb_admin_secret_arn" { value = aws_secretsmanager_secret.admin.arn }