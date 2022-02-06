terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "2.9.5"
    }
  }
}

provider proxmox {
}
