variable "aws_region" {
  description = "Regiao AWS dos recursos."
  type        = string
}

variable "environment" {
  description = "Ambiente de deploy, como hml ou prod."
  type        = string
}

variable "db_name" {
  description = "Nome do banco PostgreSQL."
  type        = string
  default     = "autocarehub"
}

variable "db_username" {
  description = "Usuario administrador da aplicacao no RDS."
  type        = string
  default     = "autocarehub"
}

variable "vpc_id" {
  description = "VPC onde o RDS sera criado."
  type        = string
}

variable "private_subnet_ids" {
  description = "Subnets privadas para o DB subnet group."
  type        = list(string)
}

variable "allowed_security_group_ids" {
  description = "Security groups autorizados a acessar o RDS na porta 5432, como EKS nodes e Lambda."
  type        = list(string)
}

variable "instance_class" {
  description = "Classe da instancia RDS."
  type        = string
  default     = "db.t4g.micro"
}

variable "allocated_storage" {
  description = "Armazenamento inicial em GB."
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Limite de autoscaling de storage em GB."
  type        = number
  default     = 100
}

variable "backup_retention_period" {
  description = "Retencao de backups em dias."
  type        = number
  default     = 7
}

variable "multi_az" {
  description = "Habilita alta disponibilidade Multi-AZ."
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Protege o RDS contra exclusao acidental."
  type        = bool
  default     = true
}
