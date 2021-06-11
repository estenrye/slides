variable "ami_id" {
  type = string
  default = "ami-08f516adc989e4efe"  # Minmal Ubuntu 20.04 2021-06-04
}

variable "ami_name" {
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

variable "ssh_username" {
  type = string
  default = "automation-user"
}

variable "ssh_password" {
  type = string
  default = "automation-user"
}

variable "iso_url" {
  type = string
  default = "packer_cache/ubuntu-20.04.2-live-server-amd64.iso"
}

variable "iso_checksum" {
  type = string
}

source "amazon-ebs" "ami_source" {
  ami_name = var.ami_name
  instance_type = var.instance_type
  region = var.region
  source_ami = var.ami_id
  ssh_username = "ubuntu"
  tags = {
    ENV = "build"
    PACKER = "yes"
    NAME = var.ami_name
  }
}

source "virtualbox-iso" "vbox-vagrant" {
  guest_os_type = "Ubuntu_64"
  vm_name = var.ami_name
  iso_url = var.iso_url
  iso_checksum = var.iso_checksum
  ssh_username = var.ssh_username
  ssh_password = var.ssh_password
  shutdown_command = "sudo -S shutdown -P now"
  guest_additions_path = "VBoxGuestAdditions_{{.Version}}.iso"
  cd_files = [
    "ubuntu/http/20.04/virtualbox/meta-data",
    "ubuntu/http/20.04/virtualbox/user-data"
  ]
  cd_label = "cidata"
  headless = false
  ssh_timeout = "1h"
  boot_wait = "5s"
  boot_command = [
        "<enter><wait><enter><wait><f6><wait><esc><wait>",
        "autoinstall",
        "<enter>"
      ]

  cpus = 2
  memory = 4096
  disk_size = 1024
  hard_drive_interface = "sata"
  sata_port_count = 8
  disk_additional_size = [ 6144, 26624, 26624, 4096, 2048, 2048, 2048 ]
}

build {
  name = "ami"
  sources = ["source.amazon-ebs.ami_source" ]

  provisioner "ansible" {
    playbook_file = "./ubuntu/ansible/20.04/provision.yml"
    extra_arguments = [
      "--extra-vars", "@./ubuntu/ansible/20.04/aws.vars.yml"
    ]
  }
}

build {
  name = "vbox-vagrant"
  sources = [ "source.virtualbox-iso.vbox-vagrant" ]

  provisioner "ansible" {
    playbook_file = "./ubuntu/ansible/20.04/provision.yml"
    extra_arguments = [
      "--extra-vars", "@./ubuntu/ansible/20.04/aws.vars.yml"
    ]
  }

}
