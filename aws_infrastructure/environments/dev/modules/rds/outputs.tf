output "rds_endpoint" {
  value = aws_db_instance.rds.endpoint # The endpoint of the RDS instance
}