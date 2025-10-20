locals {
  auth_db_name = "RPUserDB"
  be_db_name = "RPBusinessEntityDB"
  inventory_db_name = "RPInventoryDB"
  sales_db_name = "RPSalesDB"  
  payment_db_name = "RPPaymentDB"
}

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
  name = "${var.name_prefix}/db/auth-secret"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret" "be_admin" {
  name = "${var.name_prefix}/db/be-secret" 
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret" "inventory_admin" {
  name = "${var.name_prefix}/db/inventory-secret"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret" "sales_admin" {
  name = "${var.name_prefix}/db/sales-secret" 
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret" "payment_admin" {
  name = "${var.name_prefix}/db/payment-secret"
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

  db_name                 = local.auth_db_name
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

  db_name                 = local.be_db_name
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
    dbname   = local.auth_db_name
  })
  depends_on = [
    aws_db_instance.auth,
    aws_secretsmanager_secret.auth_admin
  ]
}

resource "aws_secretsmanager_secret_version" "be_admin_post" {
  secret_id = aws_secretsmanager_secret.be_admin.id
  secret_string = jsonencode({
    username = "admin"
    password = random_password.core_admin.result
    host     = aws_db_instance.core.address
    port     = 3306
    dbname   = local.be_db_name
  })
  depends_on = [
    aws_db_instance.core,
    aws_secretsmanager_secret.be_admin
  ]
}

resource "aws_secretsmanager_secret_version" "inventory_admin_post" {
  secret_id = aws_secretsmanager_secret.inventory_admin.id
  secret_string = jsonencode({
    username = "admin"
    password = random_password.core_admin.result
    host     = aws_db_instance.core.address
    port     = 3306
    dbname   = local.inventory_db_name
  })
  depends_on = [
    aws_db_instance.core,
    aws_secretsmanager_secret.inventory_admin
  ]
}

resource "aws_secretsmanager_secret_version" "sales_admin_post" {
  secret_id = aws_secretsmanager_secret.sales_admin.id
  secret_string = jsonencode({
    username = "admin"
    password = random_password.core_admin.result
    host     = aws_db_instance.core.address
    port     = 3306
    dbname   = local.sales_db_name
  })
  depends_on = [
    aws_db_instance.core,
    aws_secretsmanager_secret.sales_admin
  ]
}

resource "aws_secretsmanager_secret_version" "payment_admin_post" {
  secret_id = aws_secretsmanager_secret.payment_admin.id
  secret_string = jsonencode({
    username = "admin"
    password = random_password.core_admin.result
    host     = aws_db_instance.core.address
    port     = 3306
    dbname   = local.payment_db_name
  })
  depends_on = [
    aws_db_instance.core,
    aws_secretsmanager_secret.payment_admin
  ]
}
