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
data "aws_ami" "latest_packer_build" {
  most_recent = true
  owners           = ["self"]
}

## creating the ec2 instance pulling the latest aws_ami
resource "aws_instance" "testing" {
  ami           = data.aws_ami.latest_packer_build.id
  instance_type = "t2.micro"
  }

