variable "ami_id" {
  type = string
  default = "ami-08f516adc989e4efe"  # Minmal Ubuntu 20.04 2021-06-04
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "region" {
  type = string
  default = "us-east-2"
}

variable "ssh_username" {
  type = string
  default = "ubuntu"
}

variable "tags" {
  type = map(string)
  default = {
    ENV = "build"
    PACKER = "yes"
    NAME = "packer-ubuntu-2004-minimal-base"
  }
}

source "amazon-ebs" "ami_source" {
  ami_name = "packer-ubuntu-2004-minimal-base"
  instance_type = var.instance_type
  region = var.region
  source_ami = var.ami_id
  ssh_username = var.ssh_username
  tags = var.tags
}

build {
  sources = ["source.amazon-ebs.ami_source"]

  provisioner "ansible" {
    playbook_file = "./ubuntu/ansible/20.04/provision.yml"
  }
}
