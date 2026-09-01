module "database" {
  source                     = "../../"
  aws_region                 = var.aws_region
  environment                = "prod"
  vpc_id                     = var.vpc_id
  private_subnet_ids         = var.private_subnet_ids
  allowed_security_group_ids = var.allowed_security_group_ids
  multi_az                   = true
  deletion_protection        = true
}
