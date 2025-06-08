resource "aws_instance" "ec2" {
  count                = var.instance_count # Number of EC2 instances to create
  ami                  = var.ami_id         # AMI ID for the EC2 instance
  instance_type        = var.instance_type # Instance type (e.g., t2.micro, t2.medium)
  subnet_id            = var.subnet_id # Subnet ID where the instance will be launched
  vpc_security_group_ids = [var.security_group_id] # Security group ID to associate with the instance
  user_data = <<-EOF
              #!/bin/bash
              echo "Starting EC2 setup at $(date)" > /tmp/setup.log
              yum update -y >> /tmp/setup.log 2>&1
              if [ $? -ne 0 ]; then
                echo "Yum update failed" >> /tmp/setup.log
                exit 1
              fi
              yum install -y httpd >> /tmp/setup.log 2>&1
              if [ $? -ne 0 ]; then
                echo "HTTPD install failed" >> /tmp/setup.log
                exit 1
              fi
              systemctl start httpd >> /tmp/setup.log 2>&1
              systemctl enable httpd >> /tmp/setup.log 2>&1
              echo "Hello from EC2 instance $(hostname)" > /var/www/html/index.html
              echo "Setup completed at $(date)" >> /tmp/setup.log
              EOF

  tags = {
    Name        = "${var.environment}-ec2-${count.index + 1}"
    Environment = var.environment
  }
}