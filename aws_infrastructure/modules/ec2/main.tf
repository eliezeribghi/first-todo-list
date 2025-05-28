# EC2 instance configuration
resource "aws_instance" "web" {
  count         = var.instance_count
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  security_groups = [var.security_group_id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from ${var.environment} EC2</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "${var.environment}-web-server-${count.index + 1}"
  }
}