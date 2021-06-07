variable "environment" {
  description = "This is the lab environment instance."
  type        = string
  default     = "lab"
}

variable "ssh_public_key" {
  description = "This is the public key of the key pair used to log into instances"
  type = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDN+pva6hiM1bTWkzG6QQL51v83hnyNqDGzG/G/zqFSxygJg/yvFHbRF0rs1h+kmh5LkBrulH3BEXOgvB9a8ASUPxZBsg2E0ql20f3ke3HR7PRZN/qyDFSRWVN42prkf7qsJlfWxVQgg03/LI+ngYJv2B78wyBsal4c7EmELtMCn+Rxl9bM9a/N+4STyZzcmsI9vAHiHmbTLjRlZ5WGT4utVRgmeiuMl86oYZG7UoBWndNrbz56P0R3VtIRZKEk0OsHyj810Yv82epJzabIimXB97XPkPxejEwbf1DwCgYIynfXMURo4OJUvOREqequTE1P2LLVJDJHKTSG66d5ZmKmJdLz6Fvo9cC0TMePfEiMUlXxbIvo6jdFsaFOkds2rfjUJ5EUCYwDezNVbybxV0KTSnylzAc02JoH5Mf6gO7VQLLoD3MnGkKxOdMUWjTtJb+H2RvtFSZOHGDBkoGAoRLAuuGiB/QxDLr5zmpHV1kBQ9N/cdCMA2K+uYodCUxHBZM= esten@jumpbox"
}
