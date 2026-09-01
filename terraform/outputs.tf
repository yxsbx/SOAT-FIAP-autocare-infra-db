output "db_endpoint" {
  description = "Endpoint DNS do RDS PostgreSQL."
  value       = aws_db_instance.postgres.address
}

output "db_port" {
  description = "Porta do RDS PostgreSQL."
  value       = aws_db_instance.postgres.port
}

output "db_name" {
  description = "Nome do database da aplicacao."
  value       = var.db_name
}

output "db_secret_arn" {
  description = "ARN do secret usado pela API e pela Lambda."
  value       = aws_secretsmanager_secret.db.arn
}

output "db_security_group_id" {
  description = "Security group do RDS para liberar acesso entre repos de infra."
  value       = aws_security_group.db.id
}

output "jdbc_url" {
  description = "URL JDBC da aplicacao backend."
  value       = "jdbc:postgresql://${aws_db_instance.postgres.address}:${aws_db_instance.postgres.port}/${var.db_name}"
}
