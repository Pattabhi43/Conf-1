terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIAQ4QP2UBZMTFNL4OJ"
  secret_key = "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"
}

data "aws_ami" "ami-1" {
  owners = ["137112412989"]
  most_recent = true
}

resource "aws_instance" "master" {
  ami           = data.aws_ami.ami-1.id
  instance_type = "t2.micro"
  tags = {
    Name = "Master"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install ansible2 -y",
      "sudo yum install git -y"
    ]
  }
}

resource "aws_ec2_instance_state" "start-stop-master" {
  instance_id = aws_instance.master.id
  state = "stopped"
}

resource "aws_instance" "slaves" {
  count         = 3
  ami           = data.aws_ami.ami-1.id
  instance_type = "t2.micro"
  tags = {
    Name = "slaves"
  }
}
