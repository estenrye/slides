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
    playbook_file = "ansible/20.04/provision.yml"
    extra_arguments = [
      "--extra-vars", "@ansible/20.04/proxmox.vars.yml"
    ]
  }
}
