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

resource "aws_instance" "docker_host" {
  ami                    = "ami-01938df366ac2d954"  # Replace with a suitable Ubuntu AMI
  instance_type          = "t2.micro"
  key_name               = "RetailPulse-Sem1"
  vpc_security_group_ids = [aws_security_group.docker_sg.id]
  associate_public_ip_address = true
  
  user_data = <<-'EOF'
    #!/bin/bash
    set -e

    # Remove any older versions (if present)
    sudo apt-get remove -y docker docker-engine docker.io containerd runc || true

    # Update and install prerequisites
    sudo apt-get update -y
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

    # Set up Docker's official GPG key and repository
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update -y

    # Install Docker CE, CLI, containerd.io, and the Docker Compose plugin
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Enable and start Docker
    sudo systemctl enable docker
    sudo systemctl start docker
  EOF
}

output "server_ip" {
  value = aws_instance.docker_host.public_ip
}