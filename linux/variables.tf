variable "vm_name" {
  description = "The name of the VM"
  type        = string
  default     = "linux"
}

variable "route_through_firewall" {
  description = "Route traffic through a firewall"
  type        = bool
  default     = false
}

variable "nexthop" {
  description = "The next hop for Internet route"
  type        = string
  default     = "10.1.2.4" # VMSS or 10.1.2.105=HA
}