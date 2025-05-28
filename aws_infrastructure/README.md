# AWS Infrastructure with Terraform

This project defines an AWS infrastructure using Terraform, including a VPC, subnets, security groups, and EC2 instances.

## Structure
- `modules/`: Reusable Terraform modules for VPC, security groups, and EC2.
- `environments/`: Environment-specific configurations (dev, prod).
- `provider.tf`: AWS provider configuration.
- `variables.tf`: Global variables.
- `outputs.tf`: Global outputs.

## Prerequisites
- Terraform >= 1.5.0
- AWS account with appropriate permissions
- AWS CLI configured with access keys

## Usage
1. Initialize Terraform:
   ```bash
   terraform init