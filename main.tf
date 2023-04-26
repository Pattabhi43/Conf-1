terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "latest"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
  access_key = "AKIAQ4QP2UBZDKCANTQD"
  secret_key = "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"
}

data "aws_ami" "ami-1" {
  most_recent = true
}

resource "aws_instance" "slave-1" {
  count = 3
  ami = data.aws_ami.ami-1
  instance_type = "t2.micro"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "slaves"
  }
}