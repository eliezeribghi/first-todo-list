# Security group for the frontend
# Allows HTTP traffic on port 3000
resource "aws_security_group" "frontend_sg" {
  name        = "frontend-sg"
  description = "Security group for the frontend instance"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "HTTP for frontend"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "frontend-sg"
  }
}

# Security group for the backend
# Allows HTTP traffic on port 8000 and communication with RDS
resource "aws_security_group" "backend_sg" {
  name        = "backend-sg"
  description = "Security group for the backend instance"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "HTTP for backend"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH depuis mon Mac"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["77.202.177.247/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "backend-sg"
  }
}

# Security group for RDS
# Allows MySQL traffic from the backend and initialization instance
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Security group for the RDS instance"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description     = "MySQL from backend and init instance"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.backend_sg.id, aws_security_group.init_instance_sg.id]
  }

  tags = {
    Name = "rds-sg"
  }
}

# Security group for the initialization instance
# Allows SSH for configuration and access to S3/RDS
resource "aws_security_group" "init_instance_sg" {
  name        = "init-instance-sg"
  description = "Security group for the initialization instance"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "SSH for configuration"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict to your IP for better security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "init-instance-sg"
  }
}