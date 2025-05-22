#!/bin/bash


mkdir aws_infrastructure
cd aws_infrastructure
touch provider.tf variables.tf outputs.tf README.md
mkdir -p modules/vpc modules/security_groups modules/ec2
touch modules/vpc/main.tf modules/vpc/variables.tf modules/vpc/outputs.tf
touch modules/security_groups/main.tf modules/security_groups/variables.tf modules/security_groups/outputs.tf
touch modules/ec2/main.tf modules/ec2/variables.tf modules/ec2/outputs.tf
mkdir -p environments/dev environments/prod
touch environments/dev/main.tf environments/dev/variables.tf environments/dev/outputs.tf environments/dev/terraform.tfvars
touch environments/prod/main.tf environments/prod/variables.tf environments/prod/outputs.tf environments/prod/terraform.tfvars