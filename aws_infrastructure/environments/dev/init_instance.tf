# # IAM role for the initialization instance
# # Allows access to S3 to read the db.dump.sql file
# resource "aws_iam_role" "init_instance_role" {
#   name = "init-instance-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
# }

# # IAM policy for S3 access
# # Allows the instance to read the db.dump.sql file
# resource "aws_iam_role_policy" "init_instance_s3_policy" {
#   name = "init-instance-s3-policy"
#   role = aws_iam_role.init_instance_role.id
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = ["s3:GetObject"]
#         Resource = "${aws_s3_bucket.db_dump_bucket.arn}/db.dump.sql"
#       }
#     ]
#   })
# }

# IAM instance profile
# Associates the IAM role with the EC2 instance
# resource "aws_iam_instance_profile" "init_instance_profile" {
#   name = "init-instance-profile"
#   role = aws_iam_role.init_instance_role.name
# }

# EC2 instance for database initialization
# Runs a script to import db.dump.sql into RDS
# Instance EC2 pour l'initialisation de la base de données
# Exécute un script pour importer db.dump.sql dans RDS
resource "aws_eip" "init_instance_eip" {
  domain = "vpc"
  tags = {
  Name = "init-instance"
  ArgoCD = "test"
}
}

resource "aws_eip_association" "init_instance_eip_assoc" {
  instance_id   = aws_instance.init_instance.id
  allocation_id = aws_eip.init_instance_eip.id
}

resource "aws_instance" "init_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet[0].id
  vpc_security_group_ids = [aws_security_group.init_instance_sg.id]
  key_name               = var.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y mysql-client-core-8.0
              mysql -h ${aws_db_instance.mysql_rds.endpoint} -u ${var.db_username} -p${var.db_password} todolist < /tmp/db.sql
              shutdown -h now
              EOF

  provisioner "file" {
    source      = "/Users/eliezeribghi/Desktop/first-todo-list/database/db.dump.sql"
    destination = "/tmp/db.sql"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("/Users/eliezeribghi/Desktop/first-todo-list/aws_infrastructure/environments/dev/new-k8s-key.pem")
      host        = self.public_ip
    }
  }

  tags = {
    Name = "init-instance test"
    ArgoCD = "test_cd"
  }

  depends_on = [aws_db_instance.mysql_rds]
}
