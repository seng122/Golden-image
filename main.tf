## this is pulling the latest aws_ami
data "aws_ami" "example" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

## us-east-1
provider "aws" {
  region = "us-east-1"
}

## creating the ec2 instance pulling the latest aws_ami
resource "aws_instance" "example" {
  ami           = data.aws_ami.example.id
  instance_type = "t2.micro"
}

