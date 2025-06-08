
module "vpc" { #  VPC module for network setup
  source         = "./modules/vpc" # Path to the VPC module
  vpc_cidr       = var.vpc_cidr # CIDR block for the VPC
  subnet_cidr_a  = var.subnet_cidr_a # CIDR block for the first subnet (AZ a)
  subnet_cidr_b  = var.subnet_cidr_b # CIDR block for the second subnet (AZ b)
  aws_region     = var.aws_region # AWS region
  environment    = "dev" # Environment name
}

module "security_groups" { # Security Groups module for EC2 and RDS
  source      = "./modules/security_groups"
  vpc_id      = module.vpc.vpc_id
  environment = "dev"
}

module "ec2" { # EC2 module for instance setup
  source            = "./modules/ec2" # Path to the EC2 module
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  subnet_id         = module.vpc.subnet_ids[0]
  security_group_id = module.security_groups.security_group_id
  instance_count    = 1
  environment       = "dev"
}

module "rds" { # RDS module for database setup
  source            = "./modules/rds" # Path to the RDS module
  subnet_ids        = module.vpc.subnet_ids
  security_group_id = module.security_groups.rds_security_group_id
  db_name           = "devdb"
  environment       = "dev"
}