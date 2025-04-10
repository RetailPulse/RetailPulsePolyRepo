terraform {
  backend "s3" {
    bucket         = "rp-tofu-state-bucket"       # Replace with your S3 bucket name
    key            = "state/tofu.tfstate"           # Adjust the path as needed
    region         = "ap-southeast-1"
    dynamodb_table = "rp-tofu-state-lock"           # Replace with your DynamoDB table name, if used
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_security_group" "docker_sg" {
  name        = "docker-sg"
  description = "Allow SSH and UI access"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

resource "aws_instance" "docker_host" {
  ami                         = "ami-01938df366ac2d954"  # Use an appropriate Ubuntu AMI
  instance_type               = "t2.micro"
  key_name                    = "RetailPulse-Sem1"
  vpc_security_group_ids      = [aws_security_group.docker_sg.id]
  associate_public_ip_address = true

  user_data = <<-"EOF"
    #!/bin/bash
    # Update package lists and install prerequisites
    apt-get update -y
    apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common

    # Add Docker’s official GPG key and set up the stable repository
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

    # Update package lists again after adding the Docker repository and install Docker
    apt-get update -y
    apt-get install -y docker-ce docker-ce-cli containerd.io

    # Add the ubuntu user to the docker group to run docker commands without sudo
    usermod -aG docker ubuntu

    # Install Docker Compose
    DOCKER_COMPOSE_VERSION=2.20.2
    curl -L "https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
  EOF
}

output "server_ip" {
  value = aws_instance.docker_host.public_ip
}