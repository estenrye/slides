terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "2.6.5"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "2.14.0"
    }
  }
}

provider proxmox {
}

provider cloudflare {
}