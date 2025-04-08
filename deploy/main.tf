terraform {
  backend "s3" {
    bucket         = "rp-tofu-state-bucket"       # Replace with your S3 bucket name
    key            = "state/tofu.tfstate"           # Replace or adjust the path as needed
    region         = "ap-southeast-1"
    dynamodb_table = "rp-tofu-state-lock"           # Replace with your DynamoDB table name (if you are using one)
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

# Define a security group to allow SSH (and optionally HTTP)
resource "aws_security_group" "docker_sg" {
  name        = "docker-sg"
  description = "Allow SSH and UI access"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow UI access on port 4200
  ingress {
    from_port   = 4200
    to_port     = 4200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create the EC2 instance with Docker and Docker Compose
resource "aws_instance" "docker_host" {
  ami                    = "ami-01938df366ac2d954"  # Replace with a suitable AMI ID for your chosen OS
  instance_type          = "t2.micro"
  key_name               = "RetailPulse-Sem1"
  vpc_security_group_ids = [aws_security_group.docker_sg.id]
  associate_public_ip_address = true  # Ensures the instance gets a public IP
  
  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y docker.io docker-compose
    systemctl start docker
    systemctl enable docker
  EOF
}