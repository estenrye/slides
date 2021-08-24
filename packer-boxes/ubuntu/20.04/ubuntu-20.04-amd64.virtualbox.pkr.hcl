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
    "20.04/http/virtualbox/meta-data",
    "20.04/http/virtualbox/user-data"
  ]
  cd_label = "cidata"
  headless = true
  ssh_handshake_attempts = 1000
  ssh_timeout = "1h"
  boot_wait = "10m"

  cpus = 2
  memory = 4096
  disk_size = 1024
  hard_drive_interface = "sata"
  sata_port_count = 9
  disk_additional_size = [ 6144, 20000, 20000, 4096, 2048, 2048, 2048, 102400]
}

build {
  name = "vbox-vagrant"
  sources = [ "source.virtualbox-iso.vbox-vagrant" ]

  provisioner "ansible" {
    playbook_file = "ansible/provision.yml"
    extra_arguments = [
      "--extra-vars", "@ansible/vars/virtualbox.yml"
    ]
  }

  post-processor "artifice" {
    files = [
      "output-vbox-vagrant/${ var.vm_name }-disk001.vmdk",
      "output-vbox-vagrant/${ var.vm_name }-disk002.vmdk",
      "output-vbox-vagrant/${ var.vm_name }-disk003.vmdk",
      "output-vbox-vagrant/${ var.vm_name }-disk004.vmdk",
      "output-vbox-vagrant/${ var.vm_name }-disk005.vmdk",
      "output-vbox-vagrant/${ var.vm_name }-disk006.vmdk",
      "output-vbox-vagrant/${ var.vm_name }-disk007.vmdk",
      "output-vbox-vagrant/${ var.vm_name }-disk008.vmdk",
      "output-vbox-vagrant/${ var.vm_name }-disk009.vmdk",
      "${ var.vm_name }.ovf"
    ]
  }

  post-processor "vagrant" {
    keep_input_artifact = true
    provider_override = "virtualbox"
  }
}
