variable "ami_id" {
  type = string
  default = "ami-08f516adc989e4efe"  # Minmal Ubuntu 20.04 2021-06-04
}

variable "vm_name" {
  type = string
  default = "packer-ubuntu-2004-minimal-base-20210609"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "region" {
  type = string
  default = "us-east-2"
}

source "amazon-ebs" "ami_source" {
  ami_name = var.vm_name
  instance_type = var.instance_type
  region = var.region
  source_ami = var.ami_id
  ssh_username = "ubuntu"
  tags = {
    ENV = "build"
    PACKER = "yes"
    NAME = var.vm_name
  }
}

build {
  name = "ami"
  sources = [ "source.amazon-ebs.ami_source" ]

  provisioner "ansible" {
    playbook_file = "./ubuntu/ansible/20.04/provision.yml"
    extra_arguments = [
      "--extra-vars", "@./ubuntu/ansible/20.04/aws.vars.yml"
    ]
  }
}
