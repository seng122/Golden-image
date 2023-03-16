## this is pulling the latest aws_ami
data "aws_ami" "latest_amazon_linux" {
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
  region = "us-east-1"
}

## creating the ec2 instance pulling the latest aws_ami
resource "aws_instance" "testing" {
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = "t2.micro"
}

