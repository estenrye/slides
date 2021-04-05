resource "proxmox_vm_qemu" "machine" {
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
  qemu_os = "l26"
  desc = "Ubuntu 20.04 x86_64 template built with packer.  Username: automation-user"
  # disk_gb = 0
  sockets = 1
  ciuser = var.ciuser
  cipassword = var.cipassword
  ipconfig0 = "gw=${var.gateway_ip},ip=${each.value.ip_addr}/${var.subnet_size}"
  nameserver = "${var.nameserver_primary} ${var.nameserver_secondary}"
  sshkeys = var.ssh_keys
  network {
    bridge = "vmbr0"
    firewall = false
    link_down = false
    model = "virtio"
    queues = 0
    rate = 0
    tag = -1
    macaddr = each.value.macaddr
  }
}

