# Configuration du fournisseur AWS
# Spécifie la région AWS à utiliser, définie via une variable


# Création du VPC
# Définit un réseau virtuel isolé pour toutes les ressources
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

# Création de sous-réseaux publics
# Deux sous-réseaux dans différentes zones de disponibilité pour les instances EC2
resource "aws_subnet" "public_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

# Création de sous-réseaux privés
# Deux sous-réseaux pour RDS, isolés d'Internet pour plus de sécurité
resource "aws_subnet" "private_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false
  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

# Création d'une passerelle Internet
# Permet aux ressources publiques d'accéder à Internet
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "main-igw"
  }
}

# Table de routage pour les sous-réseaux publics
# Associe la passerelle Internet pour permettre l'accès public
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }
  tags = {
    Name = "public-route-table"
  }
}

# Association des sous-réseaux publics à la table de routage
resource "aws_route_table_association" "public_subnet_association" {
  count          = 2
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

# Instance EC2 pour le frontend
# Héberge l'application frontend, accessible publiquement
resource "aws_instance" "frontend_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet[0].id
  vpc_security_group_ids = [aws_security_group.frontend_sg.id]
  key_name               = var.key_name
  tags = {
    Name = "frontend-instance"
  }
}

# Instance EC2 pour le backend
# Héberge l'application backend, accessible publiquement
resource "aws_instance" "backend_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet[1].id
  vpc_security_group_ids = [aws_security_group.backend_sg.id]
  key_name               = var.key_name
  tags = {
    Name = "backend-instance"
  }
}

# Base de données RDS MySQL
# Base de données relationnelle dans des sous-réseaux privés pour stocker les données
resource "aws_db_instance" "mysql_rds" {
  identifier              = "mysql-db"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.rds_instance_class
  allocated_storage      = 20
  username               = var.db_username
  password               = var.db_password
  db_name                = var.db_name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  skip_final_snapshot    = true
  publicly_accessible    = false
  tags = {
    Name = "mysql-rds"
  }
}

# Groupe de sous-réseaux pour RDS
# Utilise les sous-réseaux privés pour isoler la base de données
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = aws_subnet.private_subnet[*].id
  tags = {
    Name = "rds-subnet-group"
  }
}