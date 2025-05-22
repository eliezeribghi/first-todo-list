variable "ami_id" {
  description = "ami-0953476d60561c955"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "172.31.74.0/20"
  type        = string
}

variable "security_group_id" {
  description = "sg-086331d7ffe100fed"
  type        = string
}

variable "instance_count" {
  description = "Number of EC2 instances"
  default = 2
  type        = number
}

variable "environment" {
  description = "Deployment environment (e.g., dev, prod)"
  type        = string
}