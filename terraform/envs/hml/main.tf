module "database" {
  source                     = "../../"
  aws_region                 = var.aws_region
  environment                = "hml"
  vpc_id                     = var.vpc_id
  private_subnet_ids         = var.private_subnet_ids
  allowed_security_group_ids = var.allowed_security_group_ids
  deletion_protection        = false
}
