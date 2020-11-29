data "cloudflare_zones" "ryezone_com" {
  filter {
    name = var.zone_name
  }
}

resource "cloudflare_record" "a_etcd" {
  zone_id = data.cloudflare_zones.ryezone_com.zones[0].id
  name    = "a.etcd"
  value   = var.a_etcd_ip
  type    = "A"
  proxied = false
  ttl     = 3600
}

resource "cloudflare_record" "b_etcd" {
  zone_id = data.cloudflare_zones.ryezone_com.zones[0].id
  name    = "b.etcd"
  value   = var.b_etcd_ip
  type    = "A"
  proxied = false
  ttl     = 3600
}

resource "cloudflare_record" "c_etcd" {
  zone_id = data.cloudflare_zones.ryezone_com.zones[0].id
  name    = "c.etcd"
  value   = var.c_etcd_ip
  type    = "A"
  proxied = false
  ttl     = 3600
}

resource "cloudflare_record" "a_etcd_server_ssl_etcd" {
  zone_id = data.cloudflare_zones.ryezone_com.zones[0].id
  name    = "_etcd-server-ssl._tcp.etcd"
  type    = "SRV"

  data = {
    service  = "_etcd-server-ssl"
    proto    = "_tcp"
    name     = "etcd.${data.cloudflare_zones.ryezone_com.zones[0].name}."
    port     = 2380
    target   = "${cloudflare_record.a_etcd.hostname}."
    weight   = 33
    priority = 100
  }
}

resource "cloudflare_record" "a_etcd_client_ssl_etcd" {
  zone_id = data.cloudflare_zones.ryezone_com.zones[0].id
  name    = "_etcd-client-ssl._tcp.etcd"
  type    = "SRV"

  data = {
    service  = "_etcd-client-ssl"
    proto    = "_tcp"
    name     = "etcd.${data.cloudflare_zones.ryezone_com.zones[0].name}."
    port     = 2379
    target   = "${cloudflare_record.a_etcd.hostname}."
    weight   = 33
    priority = 100
  }
}

resource "cloudflare_record" "b_etcd_server_ssl_etcd" {
  zone_id = data.cloudflare_zones.ryezone_com.zones[0].id
  name    = "_etcd-server-ssl._tcp.etcd"
  type    = "SRV"

  data = {
    service  = "_etcd-server-ssl"
    proto    = "_tcp"
    name     = "etcd.${data.cloudflare_zones.ryezone_com.zones[0].name}."
    port     = 2380
    target   = "${cloudflare_record.b_etcd.hostname}."
    weight   = 33
    priority = 100
  }
}

resource "cloudflare_record" "b_etcd_client_ssl_etcd" {
  zone_id = data.cloudflare_zones.ryezone_com.zones[0].id
  name    = "_etcd-client-ssl._tcp.etcd"
  type    = "SRV"

  data = {
    service  = "_etcd-client-ssl"
    proto    = "_tcp"
    name     = "etcd.${data.cloudflare_zones.ryezone_com.zones[0].name}."
    port     = 2379
    target   = "${cloudflare_record.b_etcd.hostname}."
    weight   = 33
    priority = 100
  }
}

resource "cloudflare_record" "c_etcd_server_ssl_etcd" {
  zone_id = data.cloudflare_zones.ryezone_com.zones[0].id
  name    = "_etcd-server-ssl._tcp.etcd"
  type    = "SRV"

  data = {
    service  = "_etcd-server-ssl"
    proto    = "_tcp"
    name     = "etcd.${data.cloudflare_zones.ryezone_com.zones[0].name}."
    port     = 2380
    target   = "${cloudflare_record.c_etcd.hostname}."
    weight   = 33
    priority = 100
  }
}

resource "cloudflare_record" "c_etcd_client_ssl_etcd" {
  zone_id = data.cloudflare_zones.ryezone_com.zones[0].id
  name    = "_etcd-client-ssl._tcp.etcd"
  type    = "SRV"

  data = {
    service  = "_etcd-client-ssl"
    proto    = "_tcp"
    name     = "etcd.${data.cloudflare_zones.ryezone_com.zones[0].name}."
    port     = 2379
    target   = "${cloudflare_record.c_etcd.hostname}."
    weight   = 33
    priority = 100
  }
}

resource "proxmox_vm_qemu" "a-etcd" {
  vmid = 1001
  name = cloudflare_record.a_etcd.hostname
  target_node = var.target_node
  clone = var.template_name
  full_clone = true
  agent = 1
  memory = 8192
  cores = 4
  sockets = 1
  ciuser = var.ciuser
  cipassword = var.cipassword
  ipconfig0 = "gw=${var.gateway_ip},ip=${var.a_etcd_ip}/${var.subnet_size}"
  nameserver = "${var.nameserver_primary} ${var.nameserver_secondary}"
  sshkeys = <<EOF
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDDZfs8GnWnZwfPbBeNf0K0D2fAYnwk3Xs4rLV4o5BXIc1zhIfuxH8mu114DQ4aNT+AyWffdR7MdyKamv3uDt6Al95AP6bV4sAjd9jEpVsfqLmkYIV8wujC6S6WLIbn2QDDhyY9a1qUz/Dedt6FeBVxRIo85P47A29JiJyNR1nYg6D0iL/PSolDApxoSqTW04mNgCaCpyhz6ds1KFba3MnGjw4LrWS0KlmbvxwgY6li1lzrn0csxShkSLLo2sdO6CSqLM9Op+zXJg3O0kKlDOn2YwDqL4e5OesXbgy4AwUtkyHumizKIkrpjGySYKO4sTa/Ia2i9MHbkj6dygSeu4GZ94a65hKFBYguYek3uC8wr/c7Lp4qCbJ2s30yAnoZ9ANSRDykiUqRKjhgzhq4A8MlyiIJi6OHvJnjzSskJQjcCcwkNwfRwe0X3/eE5EZko+eSWzodKEJP+/B0daiTonlStq5B5oV6amRo4uhnUTX6mVWNF66W6CKEGPAIa7ogGQM= esten@DESKTOP-OM0Q6UK
  EOF
}

resource "proxmox_vm_qemu" "b-etcd" {
  vmid = 1002
  name = cloudflare_record.b_etcd.hostname
  target_node = var.target_node
  clone = var.template_name
  full_clone = true
  agent = 1
  memory = 8192
  cores = 4
  sockets = 1
  ciuser = var.ciuser
  cipassword = var.cipassword
  ipconfig0 = "gw=${var.gateway_ip},ip=${var.b_etcd_ip}/${var.subnet_size}"
  nameserver = "${var.nameserver_primary} ${var.nameserver_secondary}"
  sshkeys = <<EOF
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDDZfs8GnWnZwfPbBeNf0K0D2fAYnwk3Xs4rLV4o5BXIc1zhIfuxH8mu114DQ4aNT+AyWffdR7MdyKamv3uDt6Al95AP6bV4sAjd9jEpVsfqLmkYIV8wujC6S6WLIbn2QDDhyY9a1qUz/Dedt6FeBVxRIo85P47A29JiJyNR1nYg6D0iL/PSolDApxoSqTW04mNgCaCpyhz6ds1KFba3MnGjw4LrWS0KlmbvxwgY6li1lzrn0csxShkSLLo2sdO6CSqLM9Op+zXJg3O0kKlDOn2YwDqL4e5OesXbgy4AwUtkyHumizKIkrpjGySYKO4sTa/Ia2i9MHbkj6dygSeu4GZ94a65hKFBYguYek3uC8wr/c7Lp4qCbJ2s30yAnoZ9ANSRDykiUqRKjhgzhq4A8MlyiIJi6OHvJnjzSskJQjcCcwkNwfRwe0X3/eE5EZko+eSWzodKEJP+/B0daiTonlStq5B5oV6amRo4uhnUTX6mVWNF66W6CKEGPAIa7ogGQM= esten@DESKTOP-OM0Q6UK
  EOF
}

resource "proxmox_vm_qemu" "c-etcd" {
  vmid = 1003
  name = cloudflare_record.c_etcd.hostname
  target_node = var.target_node
  clone = var.template_name
  full_clone = true
  agent = 1
  memory = 8192
  cores = 4
  sockets = 1
  ciuser = var.ciuser
  cipassword = var.cipassword
  ipconfig0 = "gw=${var.gateway_ip},ip=${var.c_etcd_ip}/${var.subnet_size}"
  nameserver = "${var.nameserver_primary} ${var.nameserver_secondary}"
  sshkeys = <<EOF
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDDZfs8GnWnZwfPbBeNf0K0D2fAYnwk3Xs4rLV4o5BXIc1zhIfuxH8mu114DQ4aNT+AyWffdR7MdyKamv3uDt6Al95AP6bV4sAjd9jEpVsfqLmkYIV8wujC6S6WLIbn2QDDhyY9a1qUz/Dedt6FeBVxRIo85P47A29JiJyNR1nYg6D0iL/PSolDApxoSqTW04mNgCaCpyhz6ds1KFba3MnGjw4LrWS0KlmbvxwgY6li1lzrn0csxShkSLLo2sdO6CSqLM9Op+zXJg3O0kKlDOn2YwDqL4e5OesXbgy4AwUtkyHumizKIkrpjGySYKO4sTa/Ia2i9MHbkj6dygSeu4GZ94a65hKFBYguYek3uC8wr/c7Lp4qCbJ2s30yAnoZ9ANSRDykiUqRKjhgzhq4A8MlyiIJi6OHvJnjzSskJQjcCcwkNwfRwe0X3/eE5EZko+eSWzodKEJP+/B0daiTonlStq5B5oV6amRo4uhnUTX6mVWNF66W6CKEGPAIa7ogGQM= esten@DESKTOP-OM0Q6UK
  EOF
}