module "vpc" {
  source      = "../../modules/vpc"
  vpc_cidr    = var.vpc_cidr
  subnet_cidr = var.subnet_cidr
  aws_region  = var.aws_region
  environment = "dev"
}

module "security_groups" {
  source      = "../../modules/security_groups"
  vpc_id      = module.vpc.vpc_id
  environment = "dev"
}

module "ec2" {
  source            = "../../modules/ec2"
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  subnet_id         = module.vpc.subnet_id
  security_group_id = module.security_groups.security_group_id
  instance_count    = var.instance_count
  environment       = "dev"
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "dev-eks"
  cluster_version = "1.29"
  subnet_ids         = [module.vpc.subnet_id]
  vpc_id          = module.vpc.vpc_id

}
