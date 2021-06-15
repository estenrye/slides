variable "vm_name" {
  type = string
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
  default = "packer_cache/custom-ubuntu-20.04.2-live-server-amd64.iso"
}

variable "iso_checksum" {
  type = string
}

variable "vcenter_server" {
  type = string
}

variable "vcenter_datacenter" {
  type = string
}

variable "vcenter_datastore" {
  type = string
}

variable "vcenter_cluster" {
  type = string
}

variable "vcenter_folder" {
  type = string
}

variable "vcenter_insecure_connection" {
  type = bool
  default = true
}

variable "vcenter_username" {
  type = string
}

variable "vcenter_password" {
  type = string
}

variable "vcenter_network" {
  type = string
}

variable "vcenter_network_card" {
  type = string
}

source "vsphere-iso" "vmware" {
  vm_name = var.vm_name
  iso_url = var.iso_url
  vcenter_server = var.vcenter_server
  datacenter = var.vcenter_datacenter
  datastore = var.vcenter_datastore
  cluster = var.vcenter_cluster
  folder = var.vcenter_folder
  insecure_connection = var.vcenter_insecure_connection
  username = var.vcenter_username
  password = var.vcenter_password
  iso_checksum = var.iso_checksum
  ssh_username = var.ssh_username
  ssh_password = var.ssh_password
  ssh_handshake_attempts = 1000
  ssh_timeout = "1h"
  boot_wait = "10m"
  shutdown_command = "sudo -S shutdown -P now"
  guest_os_type = "ubuntu64Guest"
  convert_to_template = true
  RAM = 4096
  CPUs = 2
  remove_cdrom = true

  cd_label = "cidata"
  cd_files = [
    "http/20.04/vmware/meta-data",
    "http/20.04/vmware/user-data"
  ]

  network_adapters {
    network = var.vcenter_network
    network_card = var.vcenter_network_card
  }

  disk_controller_type = [ "pvscsi" ]

  storage {
    disk_size = 1024
    disk_thin_provisioned = true
  }

  storage {
    disk_size = 6144
    disk_thin_provisioned = true
  }

  storage {
    disk_size = 20000
    disk_thin_provisioned = true
  }

  storage {
    disk_size = 20000
    disk_thin_provisioned = true
  }

  storage {
    disk_size = 4096
    disk_thin_provisioned = true
  }

  storage {
    disk_size = 2048
    disk_thin_provisioned = true
  }

  storage {
    disk_size = 2048
    disk_thin_provisioned = true
  }

  storage {
    disk_size = 2048
    disk_thin_provisioned = true
  }

  storage {
    disk_size = 2048
    disk_thin_provisioned = true
  }
}

build {
  name = "vmware"
  sources = [ "source.vsphere-iso.vmware" ]

  provisioner "ansible" {
    playbook_file = "ansible/20.04/provision.yml"
    extra_arguments = [
      "--extra-vars", "@ansible/20.04/vars/vmware.yml"
    ]
  }
}
