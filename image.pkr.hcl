packer {
  required_plugins {
    amazon = {
      version = ">= 1.1.1"
      source = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "amazon-linux" {
  ami_name      = "my-amazon-linux-ami-{{timestamp}}"
  instance_type = "t2.micro"
  region        = "us-east-1"
  ami_description = "Golden AMI created --no-public"
  source_ami_filter {
    most_recent = true
    owners      = ["amazon"]
    filters = {
      name                = "amzn2-ami-hvm-*"
      virtualization-type = "hvm"
    }
  }
  ssh_username = "ec2-user" 
}

build {
  sources = ["source.amazon-ebs.amazon-linux"]

    provisioner "shell" {
        script = "inspector.sh"
  }
}