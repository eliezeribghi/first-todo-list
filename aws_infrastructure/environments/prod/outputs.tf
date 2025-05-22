output "prod_vpc_id" {
  description = "ID of the VPC in prod"
  value       = module.vpc.vpc_id
}

output "prod_ec2_public_ips" {
  description = "Public IPs of EC2 instances in prod"
  value       = module.ec2.ec2_public_ips
}