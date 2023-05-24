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
  access_key = "AKIAQ4QP2UBZITBI6RGF"
  secret_key = "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"
}

data "aws_ami" "ami-1" {
  owners = ["137112412989"]
  most_recent = true
}

data "aws_key_pair" "master" {
  owners = ["137112412989"]
  most_recent = true
}

resource "aws_instance" "master" {
  ami           = data.aws_ami.ami-1.id
  instance_type = "t2.micro"
  key_name = data.aws_key_pair.master.key_name
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
  state = "started"
}

resource "aws_instance" "slaves" {
  count         = 3
  ami           = "ami-0b7acb262cc9ea2ea"
  instance_type = "t2.micro"
  tags = {
    Name = "slaves"
  }
}

resource "aws_ec2_instance_state" "start-stop-slave" {
  instance_id = aws_instance.slaves.id
  state = "started"
}