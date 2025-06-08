variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" { # CIDR block for the VPC
  description = "CIDR block for the VPC" 
  type        = string
  default     = "10.1.0.0/16" # Default CIDR block for the VPC
}

variable "subnet_cidr_a" { # CIDR block for the first subnet (AZ a)
  description = "CIDR block for the first subnet (AZ a)"
  type        = string
  default     = "10.1.1.0/24"
}

variable "subnet_cidr_b" { #  # CIDR block for the second subnet (AZ b)
  description = "CIDR block for the second subnet (AZ b)"
  type        = string
  default     = "10.1.2.0/24"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-0e86e20dae9224db8" # Amazon Linux 2 AMI (us-east-1)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "instance_count" {
  description = "Number of EC2 instances"
  type        = number
  default     = 1
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}