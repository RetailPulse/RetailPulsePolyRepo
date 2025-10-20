
# Strong passwords using an allowed special set (safe for RDS/DocDB); Secrets: admin passwords
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

locals {
  auth_identifier = "${var.name_prefix}-auth-mysql"
  core_identifier = "${var.name_prefix}-core-mysql"
}

# Subnet group (DB subnets)
resource "aws_db_subnet_group" "this" {
  name       = "${var.name_prefix}-mysql-subnets"
  subnet_ids = var.database_subnets
}

# Parameter group (utf8mb4)
resource "aws_db_parameter_group" "this" {
  name        = "${var.name_prefix}-mysql-params"
  family      = "mysql8.0"
  description = "Default params"

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
  parameter {
    name  = "collation_server"
    value = "utf8mb4_0900_ai_ci"
  }
}

# SG for MySQL
resource "aws_security_group" "mysql" {
  name        = "${var.name_prefix}-sg-mysql"
  description = "RDS MySQL access"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "mysql_from_eks_nodes" {
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  security_group_id        = aws_security_group.mysql.id
  source_security_group_id = var.eks_node_sg_id
}

resource "aws_security_group_rule" "mysql_egress_all" {
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.mysql.id
}

resource "aws_secretsmanager_secret" "auth_admin" {
  name = "${var.name_prefix}/db/auth/admin"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret" "core_admin" {
  name = "${var.name_prefix}/db/core/admin"
  recovery_window_in_days = 0
}

# RDS instances (auth & core)
resource "aws_db_instance" "auth" {
  identifier              = local.auth_identifier
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = var.instance_class
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.mysql.id]
  allocated_storage       = var.allocated_storage
  max_allocated_storage   = 200
  multi_az                = var.multi_az
  publicly_accessible     = false

  username                = "admin"
  password                = random_password.auth_admin.result

  db_name                 = "RPUserDB"  # initial schema; you can add others later
  apply_immediately       = true
  deletion_protection     = false
  skip_final_snapshot     = true

  parameter_group_name    = aws_db_parameter_group.this.name
}

resource "aws_db_instance" "core" {
  identifier              = local.core_identifier
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = var.instance_class
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.mysql.id]
  allocated_storage       = var.allocated_storage
  max_allocated_storage   = 200
  multi_az                = var.multi_az
  publicly_accessible     = false

  username                = "admin"
  password                = random_password.core_admin.result

  db_name                 = "RPBusinessEntityDB"
  apply_immediately       = true
  deletion_protection     = false
  skip_final_snapshot     = true

  parameter_group_name    = aws_db_parameter_group.this.name
}

resource "aws_secretsmanager_secret_version" "auth_admin_post" {
  secret_id = aws_secretsmanager_secret.auth_admin.id
  secret_string = jsonencode({
    username = "admin"
    password = random_password.auth_admin.result
    host     = aws_db_instance.auth.address
    port     = 3306
    dbname   = "user_mgmt"
  })
  depends_on = [aws_db_instance.auth]
}

resource "aws_secretsmanager_secret_version" "core_admin_post" {
  secret_id = aws_secretsmanager_secret.core_admin.id
  secret_string = jsonencode({
    username = "admin"
    password = random_password.core_admin.result
    host     = aws_db_instance.core.address
    port     = 3306
    dbname   = "business_entity"
  })
  depends_on = [aws_db_instance.core]
}