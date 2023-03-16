packer {
  required_plugins {
    amazon = {
      version = ">= 1.1.1"
      source = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "amazon-linux" {
  ami_name      = "my-amazon-linux-ami"
  ami_users     = ["self"]
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami_filter {
    most_recent = true
    owners      = ["amazon"]
    filters = {
      name                = "amzn2-ami-hvm-*"
      virtualization-type = "hvm"
    }
  }
}

build {
  sources = ["source.amazon-ebs.amazon-linux"]

  provisioner "shell" {
    inline = [
      "echo 'Hello, World!' > /tmp/hello.txt"
    ]
  }
}