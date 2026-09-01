provider "aws" {
  region = var.aws_region
}

locals {
  name = "autocarehub-${var.environment}"
  tags = {
    Project     = "AutoCareHub"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "random_password" "db" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_db_subnet_group" "main" {
  name       = local.name
  subnet_ids = var.private_subnet_ids
  tags       = local.tags
}

resource "aws_security_group" "db" {
  name        = "${local.name}-db"
  description = "Acesso privado ao PostgreSQL do AutoCare Hub"
  vpc_id      = var.vpc_id
  tags        = local.tags
}

resource "aws_security_group_rule" "db_ingress" {
  for_each                 = toset(var.allowed_security_group_ids)
  type                     = "ingress"
  description              = "PostgreSQL privado a partir de workloads autorizados"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db.id
  source_security_group_id = each.value
}

resource "aws_security_group_rule" "db_egress" {
  type              = "egress"
  description       = "Egress padrao do security group do RDS"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.db.id
}

resource "aws_db_instance" "postgres" {
  identifier                   = local.name
  engine                       = "postgres"
  engine_version               = "16"
  instance_class               = var.instance_class
  allocated_storage            = var.allocated_storage
  max_allocated_storage        = var.max_allocated_storage
  storage_type                 = "gp3"
  storage_encrypted            = true
  db_name                      = var.db_name
  username                     = var.db_username
  password                     = random_password.db.result
  db_subnet_group_name         = aws_db_subnet_group.main.name
  vpc_security_group_ids       = [aws_security_group.db.id]
  backup_retention_period      = var.backup_retention_period
  multi_az                     = var.multi_az
  deletion_protection          = var.deletion_protection
  publicly_accessible          = false
  skip_final_snapshot          = false
  final_snapshot_identifier    = "${local.name}-final"
  performance_insights_enabled = true
  auto_minor_version_upgrade   = true
  apply_immediately            = true
  tags                         = local.tags
}

resource "aws_secretsmanager_secret" "db" {
  name        = "autocarehub/${var.environment}/database"
  description = "Credenciais e endpoint do RDS PostgreSQL do AutoCare Hub"
  tags        = local.tags
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id
  secret_string = jsonencode({
    host     = aws_db_instance.postgres.address
    port     = aws_db_instance.postgres.port
    dbname   = var.db_name
    username = var.db_username
    password = random_password.db.result
  })
}
