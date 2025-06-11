# Adresse publique de l'instance frontend
# Permet d'accéder à l'URL du frontend
output "frontend_public_ip" {
  description = "Adresse IP publique de l'instance frontend"
  value       = aws_eip.frontend_eip.public_ip
}

# Adresse publique de l'instance backend
# Permet d'accéder à l'URL du backend
output "backend_public_ip" {
  description = "Adresse IP publique de l'instance backend"
  value       = aws_eip.backend_eip.public_ip
}

# Point de terminaison RDS
# Fournit l'adresse pour se connecter à la base de données
output "rds_endpoint" {
  description = "Point de terminaison de l'instance RDS"
  value       = aws_db_instance.mysql_rds.endpoint
}

# Nom du bucket S3
# Fournit le nom du bucket où le fichier SQL est stocké
output "s3_bucket_name" {
  description = "Nom du bucket S3 contenant le fichier db.dump.sql"
  value       = aws_s3_bucket.db_dump_bucket.bucket
}

# Adresse publique de l'instance d'initialisation
# Permet de se connecter via SSH pour exécuter le script d'initialisation
output "init_instance_public_ip" {
  description = "Adresse IP publique de l'instance d'initialisation"
  value       = aws_eip.init_instance_eip.public_ip
}