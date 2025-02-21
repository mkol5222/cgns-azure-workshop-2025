module "cpman" {
  // depends_on = [ azurerm_subnet.cpman_subnet ]
  #source = "github.com/mkol5222/cloudGuardIaaS-2024-09-24/terraform/azure/management-new-vnet"
  source = "github.com/CheckPointSW/CloudGuardIaaS/terraform/azure/management-new-vnet"


  client_secret   = local.spfile.password
  client_id       = local.spfile.appId
  tenant_id       = local.spfile.tenant
  subscription_id = local.spfile.subscriptionId

  source_image_vhd_uri           = "noCustomUri"
  resource_group_name            = "cpman-${local.spfile.envId}"
  mgmt_name                      = "cpman"
  location                       = "westeurope"
  vnet_name                      = "cpman"
  address_space                  = "10.3.0.0/16"
  subnet_prefix                  = "10.3.0.0/24"
  management_GUI_client_network  = "0.0.0.0/0"
  mgmt_enable_api                = "all"
  admin_password                 = "Welcome@Home#1984"
  vm_size                        = "Standard_D3_v2"
  disk_size                      = "110"
  vm_os_sku                      = "mgmt-byol"
  vm_os_offer                    = "check-point-cg-r8120"
  os_version                     = "R8120"
  bootstrap_script               = "touch /home/admin/fantomas-was-here.txt"
  allow_upload_download          = true
  authentication_type            = "Password"
  admin_shell                    = "/bin/bash"
  serial_console_password_hash   = ""
  maintenance_mode_password_hash = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  nsg_id                         = ""
  add_storage_account_ip_rules   = false
  storage_account_additional_ips = []
}

output "sp" {
  value = local.spfile
}