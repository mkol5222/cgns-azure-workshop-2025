provider "azurerm" {
  features {}
}

locals {
  spfile = jsondecode(file("../sp.json"))
}

module "standalone" {

  source  = "CheckPointSW/cloudguard-network-security/azure//modules/single_gateway_new_vnet"
  version = "1.0.4"

  source_image_vhd_uri            = "noCustomUri"
  resource_group_name             = "standalone-${local.spfile.envId}"
  single_gateway_name             = "standalone"
  location                        = "northeurope"
  vnet_name                       = "standalone-vnet"
  address_space                   = "10.84.0.0/16"
  frontend_subnet_prefix          = "10.84.101.0/24"
  backend_subnet_prefix           = "10.84.102.0/24"
  management_GUI_client_network   = "0.0.0.0/0"
  admin_password                  = "Welcome@Home#1984"
  smart_1_cloud_token             = ""
  sic_key                         = "welcomehome1984"
  vm_size                         = "Standard_D4s_v3"
  disk_size                       = "110"
  vm_os_sku                       = "sg-byol"
  vm_os_offer                     = "check-point-cg-r8120"
  os_version                      = "R8120"
  bootstrap_script                = "touch /home/admin/bootstrap.txt; echo 'hello_world' > /home/admin/bootstrap.txt"
  allow_upload_download           = true
  authentication_type             = "Password"
  enable_custom_metrics           = true
  admin_shell                     = "/bin/bash"
  installation_type               = "standalone" // "gateway"
  serial_console_password_hash    = ""
  maintenance_mode_password_hash  = ""
  nsg_id                          = ""
  add_storage_account_ip_rules    = false
  storage_account_additional_ips  = []
  is_blink               = false
}