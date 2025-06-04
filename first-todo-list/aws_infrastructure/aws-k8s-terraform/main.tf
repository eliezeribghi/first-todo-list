# Configuration du fournisseur AWS
provider "aws" {
  region = "us-east-1"
}

# Génération d'une clé privée pour SSH
resource "tls_private_key" "k8s_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Création d'une paire de clés AWS
resource "aws_key_pair" "k8s_key" {
  key_name   = "k8s-key"
  public_key = tls_private_key.k8s_key.public_key_openssh
}

# Groupe de sécurité pour le cluster Kubernetes
resource "aws_security_group" "k8s_sg" {
  name        = "k8s-sg"
  description = "Security group for Kubernetes cluster"

  # SSH restreint à votre IP pour sécurité
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["77.202.177.255/32"] 
  }

  # API Kubernetes (port 6443) pour communication cluster
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Argo CD HTTPS (port 443 au lieu de 8080 pour LoadBalancer)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restreignez à votre IP si nécessaire
  }

  # Sortie autorisée pour tout
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Instance EC2 pour le nœud maître
resource "aws_instance" "master" {
  ami                         = "ami-0fc5d935ebf8bc3bc"
  instance_type               = "t2.medium"
  key_name                    = aws_key_pair.k8s_key.key_name
  vpc_security_group_ids      = [aws_security_group.k8s_sg.id] # Corrigé : utilise vpc_security_group_ids
  associate_public_ip_address = true # Nécessaire pour l'accès initial

  tags = {
    Name = "k8s-master"
  }
}

# Instance EC2 pour le nœud worker
resource "aws_instance" "worker" {
  ami                         = "ami-0fc5d935ebf8bc3bc"
  instance_type               = "t2.medium"
  key_name                    = aws_key_pair.k8s_key.key_name
  vpc_security_group_ids      = [aws_security_group.k8s_sg.id] # Corrigé : utilise vpc_security_group_ids
  associate_public_ip_address = true # Nécessaire pour l'accès initial

  tags = {
    Name = "k8s-worker"
  }
}

# Elastic IP pour le nœud maître
resource "aws_eip" "master_eip" {
  domain = "vpc" # Spécifie que l'EIP est pour une VPC
}

# Association de l'Elastic IP au nœud maître
resource "aws_eip_association" "master_eip_assoc" {
  instance_id   = aws_instance.master.id
  allocation_id = aws_eip.master_eip.id
}

# Elastic IP pour le nœud worker
resource "aws_eip" "worker_eip" {
  domain = "vpc" # Spécifie que l'EIP est pour une VPC
}

# Association de l'Elastic IP au nœud worker
resource "aws_eip_association" "worker_eip_assoc" {
  instance_id   = aws_instance.worker.id
  allocation_id = aws_eip.worker_eip.id
}

# Sortie pour l'IP publique du maître
output "master_ip" {
  value       = aws_eip.master_eip.public_ip
  description = "IP publique statique du nœud maître"
}

# Sortie pour l'IP publique du worker
output "worker_ip" {
  value       = aws_eip.worker_eip.public_ip
  description = "IP publique statique du nœud worker"
}

# Sortie pour la clé privée SSH
output "k8s_private_key" {
  value       = tls_private_key.k8s_key.private_key_pem
  sensitive   = true
  description = "Clé privée pour l'accès SSH"
}
