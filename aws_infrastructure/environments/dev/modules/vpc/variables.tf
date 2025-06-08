variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "subnet_cidr_a" {
  description = "CIDR block for the first subnet (AZ a)"
  type        = string
}

variable "subnet_cidr_b" {
  description = "CIDR block for the second subnet (AZ b)"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}