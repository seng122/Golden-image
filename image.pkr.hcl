#Packer Plugins
packer {
  required_plugins {
    amazon = {
      version = ">= 1.1.1"
      source = "github.com/hashicorp/amazon"
    }
    googlecompute = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/googlecompute"
    }
    docker = {
      version = ">= 1.0.1"
      source  = "github.com/hashicorp/docker"
    }
}
}

# Base Image Variables (AWS,GCP,Docker)

# AWS variables
variable "aws_ubuntu_ami_filters" {
  description = "Filters for searching the latest Ubuntu AMI in AWS"
  default = {
    name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
}

# Docker variables
variable "docker_repository" {
  description = "Docker repository name for the Docker build"
  default     = "example-repo"
}
variable "docker_tag" {
  description = "Docker tag name for the Docker build"
  default     = "example-tag"
}
variable "docker_ubuntu_image" {
  description = "Docker image name for the Docker build"
  default     = "ubuntu:latest"
}

# GCP variables
variable "gcp_project_id" {
  description = "Google Cloud Project ID for the GCP build"
  default     = "example-project"
}
variable "gcp_image_family" {
  description = "Image family for the latest Ubuntu image in GCP"
  default     = "ubuntu-2004-lts"
  }


## Sources (AWS/GCP/Docker)
source "amazon-ebs" "example-ami" {
  ami_name      = var.aws_ami_name
  instance_type = "t2.micro"
  region        = "us-east-1"
  most_recent   = true

  filters = var.aws_ubuntu_ami_filters
}

source "docker" "example-container" {
  image = var.docker_ubuntu_image
}

source "googlecompute" "example-vm" {
  project_id    = var.gcp_project_id
  zone          = "us-central1-a"
  most_recent   = true

  filters = {
    family  = var.gcp_image_family
  }
}

/*
source "amazon-ebs" "amazon-linux" {
  ami_name      = "my-amazon-linux-ami"
  instance_type = "t2.micro"
  region        = "us-east-1"
  ami_description = "Golden AMI created --no-public"
  force_deregister = true
  force_delete_snapshot = true
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
*/

#build {
#  sources = ["source.amazon-ebs.amazon-linux"]
#
#    provisioner "shell" {
#        script = "inspector.sh"
#  }
#}

build {
  sources = ["sources.googlecompute.basic-example"]

    provisioner "shell" {
        script = "inspector.sh"
  }
}