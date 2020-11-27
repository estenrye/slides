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

# variable "etcd_cluster" {
#   description = "This map describes the servers in the etcd cluster."
#   type = map(object({
#     vmid = number
#     template = string
#     target_node = string
#     ip_address = string
#   }))
#   default = {
#     "a_etcd"
#   }
# }

variable "a_etcd_ip" {
  description = "This is the ip address of a.etcd.zone_name"
  type        = string
  default     = "10.5.30.10"
}

variable "b_etcd_ip" {
  description = "This is the ip address of a.etcd.zone_name"
  type        = string
  default     = "10.5.30.11"
}

variable "c_etcd_ip" {
  description = "This is the ip address of a.etcd.zone_name"
  type        = string
  default     = "10.5.30.12"
}

variable "target_node" {
  description = "This declares which proxmox node to place the VM on."
  type        = string
  default     = "proxmox01"
}

variable "template_name" {
  description = "This is the proxmox template to use when provisioning servers."
  type        = string
  default     = "ubuntu1804-tmpl"
}

variable "ciuser" {
  description = "This is the proxmox cloud init user to be created/modifies."
  type        = string
  default     = "automation_user"
}

variable "cipassword" {
  description = "This is the proxmox cloud init user password to set."
  type        = string
  default     = "test"
}