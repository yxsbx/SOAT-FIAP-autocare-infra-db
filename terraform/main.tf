provider "aws" {
  region = var.aws_region
}

resource "random_password" "db" {
  length  = 32
  special = true
}

resource "aws_db_subnet_group" "main" {
  name       = "autocarehub-${var.environment}"
  subnet_ids = var.private_subnet_ids
}

resource "aws_security_group" "db" {
  name   = "autocarehub-db-${var.environment}"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "db_ingress" {
  for_each                 = toset(var.allowed_security_group_ids)
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db.id
  source_security_group_id = each.value
}

resource "aws_db_instance" "postgres" {
  identifier              = "autocarehub-${var.environment}"
  engine                  = "postgres"
  engine_version          = "16"
  instance_class          = "db.t4g.micro"
  allocated_storage       = 20
  db_name                 = var.db_name
  username                = var.db_username
  password                = random_password.db.result
  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = [aws_security_group.db.id]
  backup_retention_period = 7
  skip_final_snapshot     = true
  publicly_accessible     = false
}

resource "aws_secretsmanager_secret" "db" {
  name = "autocarehub/${var.environment}/database"
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

output "db_endpoint" { value = aws_db_instance.postgres.address }
output "db_secret_arn" { value = aws_secretsmanager_secret.db.arn }
