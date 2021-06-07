machines = {
  # rancher.ryezone.com
  "haproxy01.rancher.ryezone.com" = {
    id = 1000
    ip_addr = "10.5.98.1"
    macaddr = "DE:AD:BE:EF:02:01"
    cores = 2
    memory = 2048
  },
  "haproxy02.rancher.ryezone.com" = {
    id = 1001
    ip_addr = "10.5.98.2"
    macaddr = "DE:AD:BE:EF:02:02"
    cores = 2
    memory = 2048
  },
  "controlplane01.rancher.ryezone.com" = {
    id = 1002
    ip_addr = "10.5.98.11"
    macaddr = "DE:AD:BE:EF:02:03"
    cores = 4
    memory = 8192
  },
  "controlplane02.rancher.ryezone.com" = {
    id = 1003
    ip_addr = "10.5.98.12"
    macaddr = "DE:AD:BE:EF:02:04"
    cores = 4
    memory = 8192
  },
  "controlplane03.rancher.ryezone.com" = {
    id = 1004
    ip_addr = "10.5.98.13"
    macaddr = "DE:AD:BE:EF:02:05"
    cores = 4
    memory = 8192
  }
}
