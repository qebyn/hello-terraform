terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

variable "instance_name" {
  description = "The name to be given to the AWS instance."
  type        = string
  default     = "Terraforminstancia"
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0b752bf1df193a6c4"
  instance_type = "t2.micro"
  vpc_security_group_ids = [
    "sg-00f6a6f34d22821b4",
  ]
  subnet_id = "subnet-0618f5dbc5a4b2f81"
  key_name  = "clavelucatic2"
  tags = {
    Name = var.instance_name
    APP  = "vue2048"
  }

  user_data = <<-EOF
    #!/bin/sh
    amazon-linux-extras install -y docker
    service docker start
    systemctl enable docker
    usermod -a -G docker ec2-user
    pip3 install docker-compose
    wget https://raw.githubusercontent.com/qebyn/hello-2048/main/docker-compose.yml
    chown ec2-user compose.yaml
    docker-compose pull
    docker-compose up -d
  EOF
}

