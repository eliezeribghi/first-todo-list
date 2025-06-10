# Création du bucket S3
# Stocke le fichier db.dump.sql de manière sécurisée
resource "aws_s3_bucket" "db_dump_bucket" {
  bucket = var.s3_bucket_name
  tags = {
    Name = "db-dump-bucket"
  }
}

# Configuration du bucket pour un accès privé
# Bloque tout accès public pour sécuriser les données
resource "aws_s3_bucket_public_access_block" "db_dump_bucket_access" {
  bucket = aws_s3_bucket.db_dump_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Upload du fichier db.dump.sql vers le bucket S3
# Copie le fichier local dans le bucket
resource "aws_s3_object" "db_dump_file" {
  bucket = aws_s3_bucket.db_dump_bucket.id
  key    = "db.dump.sql"
  source = "/Users/eliezeribghi/Desktop/first-todo-list/database/db.dump.sql"
  tags = {
    Name = "db-dump-file"
  }
}