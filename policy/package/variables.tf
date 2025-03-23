variable "cpman_admin" {
  description = "Admin user for Check Point Management Server"
  type        = string
  default     = "admin"
}

variable "cpman_pass" {
  description = "Admin password for Check Point Management Server"
  type        = string
  default     = "Welcome@Home#1984"
}

variable "cpman_ip" {
  description = "IP address of the Check Point Management Server"
  type        = string
}