output "dev_vpc_id" {
  description = "ID of the VPC in dev"
  value       = module.vpc.vpc_id
}

output "dev_ec2_public_ips" {
  description = "Public IPs of EC2 instances in dev"
  value       = module.ec2.ec2_public_ips
}