terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

## this is pulling the latest aws_ami
data "aws_ami" "latest_amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
    filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

## creating the ec2 instance pulling the latest aws_ami
resource "aws_instance" "testing" {
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = "t2.micro"
  lifecycle {
    ignore_changes = ["ami"]
  }
}

