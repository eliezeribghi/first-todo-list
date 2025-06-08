resource "aws_db_instance" "rds" {
  identifier           = "${var.environment}-rds-v3" # Nom unique pour éviter le conflit
  allocated_storage    = 20 # Taille du stockage en Go
  storage_type        = "gp2" # Type de stockage (gp2 pour SSD général)
  engine              = "mysql" # Type de base de données (MySQL)
  engine_version      = "8.0" # Version de MySQL à utiliser
  instance_class      = var.db_instance_class # Classe de l'instance (e.g., db.t3.micro)
  db_name             = var.db_name # Nom de la base de données à créer
  username            = "admin" # Nom d'utilisateur pour la base de données
  password            = "SecurePassword123!" # À remplacer par un secret manager en production
  vpc_security_group_ids = [var.security_group_id] # ID du groupe de sécurité pour la base de données
  db_subnet_group_name = aws_db_subnet_group.rds.name # Nom du groupe de sous-réseaux pour la base de données
  skip_final_snapshot  = true # Ne pas prendre de snapshot final lors de la suppression de l'instance
  multi_az             = false # Ne pas activer Multi-AZ pour la haute disponibilité

  tags = {
    Name        = "${var.environment}-rds-v3" # Nom de l'instance RDS
    Environment = var.environment  # Environnement pour le tagging
  }
}

resource "aws_db_subnet_group" "rds" { # Crée un groupe de sous-réseaux pour RDS
  name       = "${var.environment}-rds-subnet-group-v3" # Nom unique pour le groupe de sous-réseaux
  subnet_ids = var.subnet_ids # Liste des IDs de sous-réseaux où RDS sera déployé

  tags = {
    Name        = "${var.environment}-rds-subnet-group-v3" # Nom du groupe de sous-réseaux
    Environment = var.environment # Environnement pour le tagging
  }
}