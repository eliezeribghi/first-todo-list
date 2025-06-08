
module "vpc" {
  source         = "./modules/vpc"
  vpc_cidr       = var.vpc_cidr
  subnet_cidr_a  = var.subnet_cidr_a
  subnet_cidr_b  = var.subnet_cidr_b
  aws_region     = var.aws_region
  environment    = "dev"
}

module "security_groups" {
  source      = "./modules/security_groups"
  vpc_id      = module.vpc.vpc_id
  environment = "dev"
}

module "ec2" {
  source            = "./modules/ec2"
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  subnet_id         = module.vpc.subnet_ids[0]
  security_group_id = module.security_groups.security_group_id
  instance_count    = 1
  environment       = "dev"
}

module "rds" {
  source            = "./modules/rds"
  subnet_ids        = module.vpc.subnet_ids
  security_group_id = module.security_groups.rds_security_group_id
  db_name           = "devdb"
  environment       = "dev"
}