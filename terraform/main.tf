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
  region = var.region
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
    APP  = var.app_name
  }

  user_data = base64encode(templatefile("user_data.sh", {}))

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("/home/sinensia/.ssh/clavelucatic2.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "amazon-linux-extras install -y docker",
      "service docker start",
      "usermod -a -G docker ec2-user",
      "pip3 install docker-compose",
      "mkdir /home/ec2-user/hello2048",
      "cd /home/ec2-user/hello2048",
      "wget https://raw.githubusercontent.com/qebyn/hello-2048/main/docker-compose.yml",
      "docker-compose pull",
      "docker-compose up -d",
      "chown -R ec2-user:ec2-user /home/ec2-user/hello2048",
    ]
  }
}

