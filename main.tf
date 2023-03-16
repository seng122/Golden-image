## this is pulling the latest aws_ami
data "aws_ami" "example" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  owners = ["amazon"]
}

## creating the ec2 instance pulling the latest aws_ami
resource "aws_instance" "example" {
  ami           = data.aws_ami.example.id
  instance_type = "t2.micro"
}

