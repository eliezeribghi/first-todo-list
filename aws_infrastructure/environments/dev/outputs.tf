output "vpc_id" {
  description = "ID of the VPC in dev"
  value       = module.vpc.vpc_id
}

output "ec2_public_ips" {
  description = "Public IPs of EC2 instances in dev"
  value       = module.ec2.ec2_public_ips
}

output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = module.rds.rds_endpoint
}
