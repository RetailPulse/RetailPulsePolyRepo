locals { cluster_id = "${var.name_prefix}-docdb" }

resource "aws_docdb_subnet_group" "this" {
  name       = "${var.name_prefix}-docdb-subnets"
  subnet_ids = var.database_subnets
}

resource "aws_security_group" "docdb" {
  name        = "${var.name_prefix}-sg-docdb"
  description = "DocumentDB access"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "docdb_from_eks_nodes" {
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 27017
  to_port                  = 27017
  security_group_id        = aws_security_group.docdb.id
  source_security_group_id = var.eks_node_sg_id
}

resource "aws_security_group_rule" "docdb_egress_all" {
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.docdb.id
}

resource "random_password" "admin" {
  length           = 24
  special          = true
  override_special = "!#$%&()*+,-.:;<=>?[]^_{|}~"
}

resource "aws_secretsmanager_secret" "admin" {
  name = "${var.name_prefix}/db/docdb/admin"
  recovery_window_in_days = 0
}
resource "aws_secretsmanager_secret_version" "admin_post" {
  secret_id = aws_secretsmanager_secret.admin.id
  secret_string = jsonencode({
    username = var.master_username
    password = random_password.admin.result
    host     = aws_docdb_cluster.this.endpoint
    port     = var.port
    dbname   = "reportdb"
  })
  depends_on = [aws_docdb_cluster.this]
}

resource "aws_docdb_cluster" "this" {
  cluster_identifier      = local.cluster_id
  engine_version          = var.engine_version
  master_username         = var.master_username
  master_password         = random_password.admin.result
  db_subnet_group_name    = aws_docdb_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.docdb.id]
  storage_encrypted       = true
  apply_immediately       = true
  skip_final_snapshot     = true
  port                   = var.port
}

resource "aws_docdb_cluster_instance" "this" {
  count              = var.instances
  identifier         = "${local.cluster_id}-${count.index}"
  cluster_identifier = aws_docdb_cluster.this.id
  instance_class     = var.instance_class
  apply_immediately  = true
}