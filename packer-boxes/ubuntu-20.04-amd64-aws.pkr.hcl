variable "ami_id" {
  type = string
  default = "ami-08f516adc989e4efe"  # Minmal Ubuntu 20.04 2021-06-04
}

variable "vm_name" {
  type = string
  default = "packer-ubuntu-2004-minimal-base-20210609"
}

variable "proxmox_vm_id" {
  type = number
  default = 513
}

variable "template_description" {
  type = string
  default = "Ubuntu 20.04 x86_64 template built with packer."
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

variable "ssh_certificate_file" {
  type = string
  default = "~/.ssh/id_rsa"
}

variable "iso_url" {
  type = string
  default = "local:iso/ubuntu-20.04.2-live-server-amd64.iso"
}

variable "cidata_iso_url" {
  type = string
  default = "local:iso/cidata-proxmox.iso"
}

variable "cidata_iso_checksum" {
  type = string
}

variable "iso_checksum" {
  type = string
}

variable "proxmox_url" {
  type = string
  default = "https://proxmox01.ryezone.com:8006/api2/json"
}

variable "proxmox_insecure_skip_tls_verify" {
  type = bool
  default = false
}

variable "proxmox_node" {
  type = string
  default = "proxmox02"
}

variable "proxmox_network_bridge" {
  type = string
  default = "vmbr0"
}

variable "proxmox_username" {
  type = string
}

variable "proxmox_password" {
  type = string
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

source "virtualbox-iso" "vbox-vagrant" {
  guest_os_type = "Ubuntu_64"
  vm_name = var.vm_name
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
  headless = true
  ssh_handshake_attempts = 1000
  ssh_timeout = "1h"
  boot_wait = "20m"

  cpus = 2
  memory = 4096
  disk_size = 1024
  hard_drive_interface = "sata"
  sata_port_count = 8
  disk_additional_size = [ 6144, 26624, 26624, 4096, 2048, 2048, 2048 ]
}

source "proxmox-iso" "proxmox" {
  proxmox_url = var.proxmox_url
  insecure_skip_tls_verify = var.proxmox_insecure_skip_tls_verify
  username = var.proxmox_username
  password = var.proxmox_password
  vm_id = var.proxmox_vm_id
  vm_name = var.vm_name
  qemu_agent = true
  template_name = var.vm_name
  template_description = var.template_description
  memory = 4096
  cores = 2
  os = "l26"
  node = var.proxmox_node
  ssh_username = var.ssh_username
  ssh_password = var.ssh_password
  ssh_certificate_file = var.ssh_certificate_file
  ssh_timeout = "60m"
  iso_file = var.iso_url
  iso_checksum = var.iso_checksum
  iso_storage_pool = "local"
  unmount_iso = true
  cloud_init = false
  cloud_init_storage_pool = "local-lvm"

  additional_iso_files {
    device = "scsi5"
    iso_file = var.cidata_iso_url
    iso_checksum = var.cidata_iso_checksum
    unmount = true
  }

  boot = "order=virtio0;ide2;net0"
  boot_wait = "5s"
  http_directory = "ubuntu/http/20.04/proxmox"
  boot_command = [
    "<enter><enter><f6><esc><wait>",
    "autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/",
    "<enter>"
  ]

  network_adapters {
    model = "virtio"
    bridge = var.proxmox_network_bridge
  }

  disks {
    type = "virtio"
    disk_size = "1G"
    storage_pool = "local-lvm"
    storage_pool_type = "lvm-thin"
    format = "qcow2"
  }

  disks {
    type = "virtio"
    disk_size = "6G"
    storage_pool = "local-lvm"
    storage_pool_type = "lvm-thin"
    format = "qcow2"
  }

  disks {
    type = "virtio"
    disk_size = "20G"
    storage_pool = "local-lvm"
    storage_pool_type = "lvm-thin"
    format = "qcow2"
  }

  disks {
    type = "virtio"
    disk_size = "20G"
    storage_pool = "local-lvm"
    storage_pool_type = "lvm-thin"
    format = "qcow2"
  }

  disks {
    type = "virtio"
    disk_size = "4G"
    storage_pool = "local-lvm"
    storage_pool_type = "lvm-thin"
    format = "qcow2"
  }

  disks {
    type = "virtio"
    disk_size = "2G"
    storage_pool = "local-lvm"
    storage_pool_type = "lvm-thin"
    format = "qcow2"
  }

  disks {
    type = "virtio"
    disk_size = "2G"
    storage_pool = "local-lvm"
    storage_pool_type = "lvm-thin"
    format = "qcow2"
  }

  disks {
    type = "virtio"
    disk_size = "2G"
    storage_pool = "local-lvm"
    storage_pool_type = "lvm-thin"
    format = "qcow2"
  }
}

build {
  name = "proxmox"
  sources = [ "source.proxmox-iso.proxmox" ]

  provisioner "ansible" {
    playbook_file = "./ubuntu/ansible/20.04/provision.yml"
    extra_arguments = [
      "--extra-vars", "@./ubuntu/ansible/20.04/proxmox.vars.yml"
    ]
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

build {
  name = "vbox-vagrant"
  sources = [ "source.virtualbox-iso.vbox-vagrant" ]

  provisioner "ansible" {
    playbook_file = "./ubuntu/ansible/20.04/provision.yml"
    extra_arguments = [
      "--extra-vars", "@./ubuntu/ansible/20.04/virtualbox.vars.yml"
    ]
  }

  post-processor "artifice" {
    files = [
      "output-vbox-vagrant/packer-ubuntu-2004-minimal-base-20210609-disk001.vmdk",
      "output-vbox-vagrant/packer-ubuntu-2004-minimal-base-20210609-disk002.vmdk",
      "output-vbox-vagrant/packer-ubuntu-2004-minimal-base-20210609-disk003.vmdk",
      "output-vbox-vagrant/packer-ubuntu-2004-minimal-base-20210609-disk004.vmdk",
      "output-vbox-vagrant/packer-ubuntu-2004-minimal-base-20210609-disk005.vmdk",
      "output-vbox-vagrant/packer-ubuntu-2004-minimal-base-20210609-disk006.vmdk",
      "output-vbox-vagrant/packer-ubuntu-2004-minimal-base-20210609-disk007.vmdk",
      "output-vbox-vagrant/packer-ubuntu-2004-minimal-base-20210609-disk008.vmdk",
      "packer-ubuntu-2004-minimal-base-20210609.ovf"
    ]
  }

  post-processor "vagrant" {
    keep_input_artifact = true
    provider_override = "virtualbox"
  }
}
