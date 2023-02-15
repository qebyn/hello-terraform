terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
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
    Name = "Terraforminstancia"
    APP  = "vue2048"
  }
}


