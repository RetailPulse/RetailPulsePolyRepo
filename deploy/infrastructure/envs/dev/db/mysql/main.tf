#############################################
# Local DB names for logical schemas
#############################################
locals {
  auth_db_name      = "RPUserDB"
  be_db_name        = "RPBusinessEntityDB"
  inventory_db_name = "RPInventoryDB"
  sales_db_name     = "RPSalesDB"
  payment_db_name   = "RPPaymentDB"

  auth_identifier = "${var.name_prefix}-auth-mysql"
  core_identifier = "${var.name_prefix}-core-mysql"
}

#############################################
# Strong passwords for DB admin users
#############################################
resource "random_password" "auth_admin" {
  length           = 24
  special          = true
  override_special = "!#$%&()*+,-.:;<=>?[]^_{|}~"
}

resource "random_password" "core_admin" {
  length           = 24
  special          = true
  override_special = "!#$%&()*+,-.:;<=>?[]^_{|}~"
}

#############################################
# Subnet group (Aurora must span multiple AZs)
#############################################
resource "aws_db_subnet_group" "this" {
  name       = "${var.name_prefix}-mysql-subnets"
  subnet_ids = var.database_subnets
  tags = {
    Name = "${var.name_prefix}-mysql-subnets"
  }
}

#############################################
# Parameter group for Aurora MySQL
# (Important: family must match Aurora, not vanilla MySQL)
#############################################
resource "aws_rds_cluster_parameter_group" "this" {
  name        = "${var.name_prefix}-mysql-cluster-params"
  family      = "aurora-mysql8.0"
  description = "Aurora MySQL cluster parameter group"

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  parameter {
    name  = "collation_server"
    value = "utf8mb4_0900_ai_ci"
  }
}

#############################################
# Security Group for Aurora MySQL
#############################################
resource "aws_security_group" "mysql" {
  name        = "${var.name_prefix}-sg-mysql"
  description = "Aurora MySQL access"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name_prefix}-sg-mysql"
  }
}

# allow EKS nodes (app layer) to connect to DB port 3306
resource "aws_security_group_rule" "mysql_from_eks_nodes" {
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  security_group_id        = aws_security_group.mysql.id
  source_security_group_id = var.eks_node_sg_id
}

# allow DBs to talk out (patching, backup to S3 endpoints, etc.)
resource "aws_security_group_rule" "mysql_egress_all" {
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.mysql.id
}

#############################################
# Secrets Manager (one secret per logical service/schema)
#############################################
resource "aws_secretsmanager_secret" "auth_admin" {
  name                    = "${var.name_prefix}/db/auth-secret"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret" "be_admin" {
  name                    = "${var.name_prefix}/db/be-secret"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret" "inventory_admin" {
  name                    = "${var.name_prefix}/db/inventory-secret"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret" "sales_admin" {
  name                    = "${var.name_prefix}/db/sales-secret"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret" "payment_admin" {
  name                    = "${var.name_prefix}/db/payment-secret"
  recovery_window_in_days = 0
}

#############################################
# Aurora MySQL Cluster: AUTH
# 1 writer + 2 readers across 1a / 1b / 1c
#############################################
resource "aws_rds_cluster" "auth" {
  cluster_identifier       = "${var.name_prefix}-auth-cluster"
  engine                   = "aurora-mysql"
  engine_version           = "8.0.mysql_aurora.3.04.0"
  master_username          = "admin"
  master_password          = random_password.auth_admin.result
  database_name            = "authdb"
  db_subnet_group_name     = aws_db_subnet_group.this.name
  vpc_security_group_ids   = [aws_security_group.mysql.id]
  backup_retention_period  = 7
  storage_encrypted        = true
  deletion_protection      = false
  apply_immediately        = true
  skip_final_snapshot      = true
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.this.name
}

# Writer in ap-southeast-1a
resource "aws_rds_cluster_instance" "auth_writer" {
  identifier                   = "${var.name_prefix}-auth-writer"
  cluster_identifier           = aws_rds_cluster.auth.id
  instance_class               = var.instance_class
  engine                       = aws_rds_cluster.auth.engine
  availability_zone            = "ap-southeast-1a"
  publicly_accessible          = false
  auto_minor_version_upgrade   = true
}

# Reader in ap-southeast-1b
resource "aws_rds_cluster_instance" "auth_reader_1" {
  identifier                   = "${var.name_prefix}-auth-reader-1"
  cluster_identifier           = aws_rds_cluster.auth.id
  instance_class               = var.instance_class
  engine                       = aws_rds_cluster.auth.engine
  availability_zone            = "ap-southeast-1b"
  publicly_accessible          = false
  auto_minor_version_upgrade   = true
}

# Reader in ap-southeast-1c
resource "aws_rds_cluster_instance" "auth_reader_2" {
  identifier                   = "${var.name_prefix}-auth-reader-2"
  cluster_identifier           = aws_rds_cluster.auth.id
  instance_class               = var.instance_class
  engine                       = aws_rds_cluster.auth.engine
  availability_zone            = "ap-southeast-1c"
  publicly_accessible          = false
  auto_minor_version_upgrade   = true
}

#############################################
# Aurora MySQL Cluster: CORE
# 1 writer + 2 readers across 1a / 1b / 1c
#############################################
resource "aws_rds_cluster" "core" {
  cluster_identifier       = "${var.name_prefix}-core-cluster"
  engine                   = "aurora-mysql"
  engine_version           = "8.0.mysql_aurora.3.04.0"
  master_username          = "admin"
  master_password          = random_password.core_admin.result
  database_name            = "coredb"
  db_subnet_group_name     = aws_db_subnet_group.this.name
  vpc_security_group_ids   = [aws_security_group.mysql.id]
  backup_retention_period  = 7
  storage_encrypted        = true
  deletion_protection      = false
  apply_immediately        = true
  skip_final_snapshot      = true
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.this.name
}

# Writer in ap-southeast-1a
resource "aws_rds_cluster_instance" "core_writer" {
  identifier                   = "${var.name_prefix}-core-writer"
  cluster_identifier           = aws_rds_cluster.core.id
  instance_class               = var.instance_class
  engine                       = aws_rds_cluster.core.engine
  availability_zone            = "ap-southeast-1a"
  publicly_accessible          = false
  auto_minor_version_upgrade   = true
}

# Reader in ap-southeast-1b
resource "aws_rds_cluster_instance" "core_reader_1" {
  identifier                   = "${var.name_prefix}-core-reader-1"
  cluster_identifier           = aws_rds_cluster.core.id
  instance_class               = var.instance_class
  engine                       = aws_rds_cluster.core.engine
  availability_zone            = "ap-southeast-1b"
  publicly_accessible          = false
  auto_minor_version_upgrade   = true
}

# Reader in ap-southeast-1c
resource "aws_rds_cluster_instance" "core_reader_2" {
  identifier                   = "${var.name_prefix}-core-reader-2"
  cluster_identifier           = aws_rds_cluster.core.id
  instance_class               = var.instance_class
  engine                       = aws_rds_cluster.core.engine
  availability_zone            = "ap-southeast-1c"
  publicly_accessible          = false
  auto_minor_version_upgrade   = true
}

#############################################
# Secrets Manager: final secret values
# NOTE:
#  - We now point to aws_rds_cluster.<cluster>.endpoint instead of aws_db_instance.*
#  - Each secret is still per logical schema (your original design)
#############################################

resource "aws_secretsmanager_secret_version" "auth_admin_post" {
  secret_id = aws_secretsmanager_secret.auth_admin.id
  secret_string = jsonencode({
    username = "admin"
    password = random_password.auth_admin.result
    host     = aws_rds_cluster.auth.endpoint
    port     = 3306
    dbname   = local.auth_db_name
  })
  depends_on = [
    aws_rds_cluster.auth,
    aws_secretsmanager_secret.auth_admin
  ]
}

resource "aws_secretsmanager_secret_version" "be_admin_post" {
  secret_id = aws_secretsmanager_secret.be_admin.id
  secret_string = jsonencode({
    username = "admin"
    password = random_password.core_admin.result
    host     = aws_rds_cluster.core.endpoint
    port     = 3306
    dbname   = local.be_db_name
  })
  depends_on = [
    aws_rds_cluster.core,
    aws_secretsmanager_secret.be_admin
  ]
}

resource "aws_secretsmanager_secret_version" "inventory_admin_post" {
  secret_id = aws_secretsmanager_secret.inventory_admin.id
  secret_string = jsonencode({
    username = "admin"
    password = random_password.core_admin.result
    host     = aws_rds_cluster.core.endpoint
    port     = 3306
    dbname   = local.inventory_db_name
  })
  depends_on = [
    aws_rds_cluster.core,
    aws_secretsmanager_secret.inventory_admin
  ]
}

resource "aws_secretsmanager_secret_version" "sales_admin_post" {
  secret_id = aws_secretsmanager_secret.sales_admin.id
  secret_string = jsonencode({
    username = "admin"
    password = random_password.core_admin.result
    host     = aws_rds_cluster.core.endpoint
    port     = 3306
    dbname   = local.sales_db_name
  })
  depends_on = [
    aws_rds_cluster.core,
    aws_secretsmanager_secret.sales_admin
  ]
}

resource "aws_secretsmanager_secret_version" "payment_admin_post" {
  secret_id = aws_secretsmanager_secret.payment_admin.id
  secret_string = jsonencode({
    username = "admin"
    password = random_password.core_admin.result
    host     = aws_rds_cluster.core.endpoint
    port     = 3306
    dbname   = local.payment_db_name
  })
  depends_on = [
    aws_rds_cluster.core,
    aws_secretsmanager_secret.payment_admin
  ]
}
