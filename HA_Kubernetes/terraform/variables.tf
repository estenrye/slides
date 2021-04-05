variable "zone_name" {
  description = "This is the root zone to add dns entries to."
  type        = string
  default     = "ryezone.com"
}

variable "gateway_ip" {
  description = "This is the ip address of the gateway."
  type        = string
  default     = "10.5.0.1"
}

variable "subnet_size" {
  description = "This tells proxmox cloud init how big the subnet is."
  type        = number
  default     = 16
}

variable "nameserver_primary" {
  description = "This tells proxmox cloud init the address of the primary DNS server"
  type        = string
  default     = "1.1.1.1"
}

variable "nameserver_secondary" {
  description = "This tells proxmox cloud init the address of the secondary DNS server"
  type        = string
  default     = "1.0.0.1"
}

variable "use_full_clones" {
  type = bool
  default = true
}

variable machines {
  default = {
    "haproxy01.dev.ryezone.com" = {
      id = 2001
      ip_addr = "10.5.99.18"
      macaddr = "D6:9E:E6:33:27:4A"
      cores = 2
      memory = 2048
    },
    "haproxy02.dev.ryezone.com" = {
      id = 2002
      ip_addr = "10.5.99.19"
      macaddr = "CE:82:45:FF:0E:64"
      cores = 2
      memory = 2048
    },
    "haproxy01.rancher.ryezone.com" = {
      id = 2003
      ip_addr = "10.5.99.15"
      macaddr = "86:CA:1C:ED:0D:D4"
      cores = 2
      memory = 2048
    },
    "haproxy02.rancher.ryezone.com" = {
      id = 2004
      ip_addr = "10.5.99.16"
      macaddr = "BE:57:17:29:4C:10"
      cores = 2
      memory = 2048
    },
    "controlplane01.dev.ryezone.com" = {
      id = 2101
      ip_addr = "10.5.99.21"
      macaddr = "3E:24:9D:03:78:BD"
      cores = 4
      memory = 4096
    },
    "controlplane02.dev.ryezone.com" = {
      id = 2102
      ip_addr = "10.5.99.22"
      macaddr = "DE:F7:43:49:35:56"
      cores = 4
      memory = 4096
    },
    "controlplane03.dev.ryezone.com" = {
      id = 2103
      ip_addr = "10.5.99.23"
      macaddr = "C6:EC:56:25:60:3F"
      cores = 4
      memory = 4096
    },
    "controlplane01.rancher.ryezone.com" = {
      id = 2104
      ip_addr = "10.5.99.24"
      macaddr = ""
      cores = 4
      memory = 8192
    },
    "controlplane02.rancher.ryezone.com" = {
      id = 2105
      ip_addr = "10.5.99.25"
      macaddr = ""
      cores = 4
      memory = 8192
    },
    "controlplane03.rancher.ryezone.com" = {
      id = 2106
      ip_addr = "10.5.99.26"
      macaddr = "26:5D:E8:78:11:2F"
      cores = 4
      memory = 8192
    },
    "node01.dev.ryezone.com" = {
      id = 2111
      ip_addr = "10.5.99.31"
      macaddr = "AE:82:C7:6F:99:D9"
      cores = 8
      memory = 8192
    },
    "node02.dev.ryezone.com" = {
      id = 2112
      ip_addr = "10.5.99.32"
      macaddr = "7A:3B:60:4C:29:45"
      cores = 8
      memory = 8192
    },
    "node03.dev.ryezone.com" = {
      id = 2113
      ip_addr = "10.5.99.33"
      macaddr = "32:38:D2:7C:E5:C4"
      cores = 8
      memory = 8192
    }
  }
}

variable "ssh_keys" {
  type = string
  default = <<EOF
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDN+pva6hiM1bTWkzG6QQL51v83hnyNqDGzG/G/zqFSxygJg/yvFHbRF0rs1h+kmh5LkBrulH3BEXOgvB9a8ASUPxZBsg2E0ql20f3ke3HR7PRZN/qyDFSRWVN42prkf7qsJlfWxVQgg03/LI+ngYJv2B78wyBsal4c7EmELtMCn+Rxl9bM9a/N+4STyZzcmsI9vAHiHmbTLjRlZ5WGT4utVRgmeiuMl86oYZG7UoBWndNrbz56P0R3VtIRZKEk0OsHyj810Yv82epJzabIimXB97XPkPxejEwbf1DwCgYIynfXMURo4OJUvOREqequTE1P2LLVJDJHKTSG66d5ZmKmJdLz6Fvo9cC0TMePfEiMUlXxbIvo6jdFsaFOkds2rfjUJ5EUCYwDezNVbybxV0KTSnylzAc02JoH5Mf6gO7VQLLoD3MnGkKxOdMUWjTtJb+H2RvtFSZOHGDBkoGAoRLAuuGiB/QxDLr5zmpHV1kBQ9N/cdCMA2K+uYodCUxHBZM= esten@jumpbox
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDDZfs8GnWnZwfPbBeNf0K0D2fAYnwk3Xs4rLV4o5BXIc1zhIfuxH8mu114DQ4aNT+AyWffdR7MdyKamv3uDt6Al95AP6bV4sAjd9jEpVsfqLmkYIV8wujC6S6WLIbn2QDDhyY9a1qUz/Dedt6FeBVxRIo85P47A29JiJyNR1nYg6D0iL/PSolDApxoSqTW04mNgCaCpyhz6ds1KFba3MnGjw4LrWS0KlmbvxwgY6li1lzrn0csxShkSLLo2sdO6CSqLM9Op+zXJg3O0kKlDOn2YwDqL4e5OesXbgy4AwUtkyHumizKIkrpjGySYKO4sTa/Ia2i9MHbkj6dygSeu4GZ94a65hKFBYguYek3uC8wr/c7Lp4qCbJ2s30yAnoZ9ANSRDykiUqRKjhgzhq4A8MlyiIJi6OHvJnjzSskJQjcCcwkNwfRwe0X3/eE5EZko+eSWzodKEJP+/B0daiTonlStq5B5oV6amRo4uhnUTX6mVWNF66W6CKEGPAIa7ogGQM= esten@DESKTOP-OM0Q6UK
  EOF
}

variable "target_node" {
  description = "This declares which proxmox node to place the VM on."
  type        = string
  default     = "proxmox02"
}

variable "template_name" {
  description = "This is the proxmox template to use when provisioning servers."
  type        = string
  default     = "ubuntu2004-tmpl-509"
}

variable "ciuser" {
  description = "This is the proxmox cloud init user to be created/modifies."
  type        = string
  default     = "automation-user"
}

variable "cipassword" {
  description = "This is the proxmox cloud init user password to set."
  type        = string
  default     = "test"
}
