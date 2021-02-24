resource "proxmox_vm_qemu" "a-etcd" {
  for_each = var.machines

  vmid = each.value.id
  name = each.key
  target_node = var.target_node
  clone = var.template_name
  full_clone = var.use_full_clones
  agent = 1
  memory = each.value.memory
  cores = each.value.cores
  boot = "c"
  bootdisk = "virtio0"
  preprovision = true
  sockets = 1
  ciuser = var.ciuser
  cipassword = var.cipassword
  ipconfig0 = "gw=${var.gateway_ip},ip=${each.value.ip_addr}/${var.subnet_size}"
  nameserver = "${var.nameserver_primary} ${var.nameserver_secondary}"
  sshkeys = var.ssh_keys
}
