resource "aws_db_instance" "rds" {
  identifier           = "${var.environment}-rds-v3" # Nom unique pour éviter le conflit
  allocated_storage    = 20
  storage_type        = "gp2"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = var.db_instance_class
  db_name             = var.db_name
  username            = "admin"
  password            = "SecurePassword123!" # À remplacer par un secret manager en production
  vpc_security_group_ids = [var.security_group_id]
  db_subnet_group_name = aws_db_subnet_group.rds.name
  skip_final_snapshot  = true
  multi_az             = false

  tags = {
    Name        = "${var.environment}-rds-v3"
    Environment = var.environment
  }
}

resource "aws_db_subnet_group" "rds" {
  name       = "${var.environment}-rds-subnet-group-v3"
  subnet_ids = var.subnet_ids

  tags = {
    Name        = "${var.environment}-rds-subnet-group-v3"
    Environment = var.environment
  }
}