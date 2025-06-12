# Région AWS
# Spécifie la région où les ressources seront déployées
variable "aws_region" {
  description = "Région AWS pour le déploiement des ressources"
  type        = string
  default     = "us-east-1"
}

# CIDR du VPC
# Plage d'adresses IP pour le VPC
variable "vpc_cidr" {
  description = "Bloc CIDR pour le VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# CIDR des sous-réseaux publics
# Plages d'adresses IP pour les sous-réseaux publics
variable "public_subnet_cidrs" {
  description = "Blocs CIDR pour les sous-réseaux publics"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

# CIDR des sous-réseaux privés
# Plages d'adresses IP pour les sous-réseaux privés (RDS)
variable "private_subnet_cidrs" {
  description = "Blocs CIDR pour les sous-réseaux privés"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

# Zones de disponibilité
# Liste des zones de disponibilité pour les sous-réseaux
variable "availability_zones" {
  description = "Zones de disponibilité AWS"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# ID de l'AMI
# Image pour les instances EC2 (Ubuntu 20.04 LTS dans us-east-1)
variable "ami_id" {
  description = "ID de l'AMI pour les instances EC2"
  type        = string
  default     = "ami-04a81a99f5ec58529" # Vérifiez dans votre région
}

# Type d'instance EC2
# Spécifie la taille des instances EC2
variable "instance_type" {
  description = "Type d'instance EC2"
  type        = string
  default     = "t2.micro"
}

# Nom de la clé SSH
# Clé pour accéder aux instances EC2
variable "key_name" {
  description = "Nom de la clé SSH pour les instances EC2"
  type        = string
  default     = "new-k8s-key" # Remplacez par votre clé SSH
}

# Type d'instance RDS
# Spécifie la taille de l'instance RDS
variable "rds_instance_class" {
  description = "Type d'instance pour RDS"
  type        = string
  default     = "db.t3.micro"
}

# Nom de la base de données
variable "db_name" {
  description = "Nom de la base de données"
  type        = string
  default     = "mydb"
}

# Nom d'utilisateur de la base de données
variable "db_username" {
  description = "Nom d'utilisateur pour RDS"
  type        = string
  default     = "admin"
}

# Mot de passe de la base de données
variable "db_password" {
  description = "Mot de passe pour RDS"
  type        = string
  sensitive   = true
  default     = "your-secure-password" # Remplacez par un mot de passe sécurisé
}

# Nom du bucket S3
# Nom unique pour le bucket qui stocke le fichier SQL
variable "s3_bucket_name" {
  description = "Nom du bucket S3 pour stocker le fichier SQL"
  type        = string
  default     = "my-todo-list-db-dump"
}

# Clé d'accès AWS
# Utilisée pour accéder à S3 depuis l'instance d'initialisation
variable "aws_access_key_id" {
  description = "Clé d'accès AWS pour l'instance d'initialisation"
  type        = string
  sensitive   = true
}

# Clé secrète AWS
# Utilisée pour accéder à S3 depuis l'instance d'initialisation
variable "aws_secret_access_key" {
  description = "Clé secrète AWS pour l'instance d'initialisation"
  type        = string
  sensitive   = true
}
# Clé privée SSH
variable "ssh_private_key" {
  description = "Clé privée SSH pour accéder aux instances EC2"
  type        = string
  sensitive   = true

}