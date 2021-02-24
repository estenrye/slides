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
  default = false
}

variable machines {
  default = {
    "haproxy01.dev.ryezone.com" = {
      id = 2001
      ip_addr = "10.5.99.18"
      cores = 2
      memory = 2048
    },
    "haproxy02.dev.ryezone.com" = {
      id = 2002
      ip_addr = "10.5.99.19"
      cores = 2
      memory = 2048
    },
    "controlplane01.dev.ryezone.com" = {
      id = 2101
      ip_addr = "10.5.99.21"
      cores = 4
      memory = 4096
    },
    "controlplane02.dev.ryezone.com" = {
      id = 2102
      ip_addr = "10.5.99.22"
      cores = 4
      memory = 4096
    },
    "controlplane03.dev.ryezone.com" = {
      id = 2103
      ip_addr = "10.5.99.23"
      cores = 4
      memory = 4096
    },
    "node01.dev.ryezone.com" = {
      id = 2111
      ip_addr = "10.5.99.31"
      cores = 8
      memory = 8192
    },
    "node02.dev.ryezone.com" = {
      id = 2112
      ip_addr = "10.5.99.32"
      cores = 8
      memory = 8192
    },
    "node03.dev.ryezone.com" = {
      id = 2113
      ip_addr = "10.5.99.33"
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
  default     = "proxmox01"
}

variable "template_name" {
  description = "This is the proxmox template to use when provisioning servers."
  type        = string
  default     = "ubuntu2004-tmpl-507"
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
