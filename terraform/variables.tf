variable "aws_region" { type = string }
variable "environment" { type = string }
variable "db_name" { type = string }
variable "db_username" { type = string }
variable "vpc_id" { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "allowed_security_group_ids" { type = list(string) }
