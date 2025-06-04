# Configuring the AWS provider
# Configuration du provider AWS
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.aws_region
  # Optionnel : Spécifier un profil si plusieurs configurations AWS CLI existent
  # profile = "default"
}