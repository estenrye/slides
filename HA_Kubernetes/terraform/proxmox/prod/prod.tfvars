machines = {
  # prod.ryezone.com
  "haproxy01.prod.ryezone.com" = {
    id = 1200
    ip_addr = "10.5.100.1"
    macaddr = "DE:AD:BE:EF:02:4A"
    cores = 2
    memory = 2048
  },
  "haproxy02.prod.ryezone.com" = {
    id = 1201
    ip_addr = "10.5.100.2"
    macaddr = "DE:AD:BE:EF:02:64"
    cores = 2
    memory = 2048
  },
  "controlplane01.prod.ryezone.com" = {
    id = 1202
    ip_addr = "10.5.100.11"
    macaddr = "DE:AD:BE:EF:02:BD"
    cores = 4
    memory = 4096
  },
  "controlplane02.prod.ryezone.com" = {
    id = 1203
    ip_addr = "10.5.100.12"
    macaddr = "DE:AD:BE:EF:02:56"
    cores = 2
    memory = 4096
  },
  "controlplane03.prod.ryezone.com" = {
    id = 1204
    ip_addr = "10.5.100.13"
    macaddr = "DE:AD:BE:EF:02:3F"
    cores = 2
    memory = 4096
  },
  "node01.prod.ryezone.com" = {
    id = 1205
    ip_addr = "10.5.100.31"
    macaddr = "DE:AD:BE:EF:02:D9"
    cores = 4
    memory = 8192
  },
  "node02.prod.ryezone.com" = {
    id = 1206
    ip_addr = "10.5.100.32"
    macaddr = "DE:AD:BE:EF:02:45"
    cores = 4
    memory = 8192
  },
  "node03.prod.ryezone.com" = {
    id = 1207
    ip_addr = "10.5.100.33"
    macaddr = "DE:AD:BE:EF:02:C4"
    cores = 4
    memory = 8192
  }
}
