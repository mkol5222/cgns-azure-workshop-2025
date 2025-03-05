module "vmss" {
   
  source = "github.com/CheckPointSW/CloudGuardIaaS/terraform/azure/vmss-new-vnet"

  client_secret   = local.spfile.password
  client_id       = local.spfile.appId
  tenant_id       = local.spfile.tenant
  subscription_id = local.spfile.subscriptionId

  source_image_vhd_uri           = "noCustomUri"
  resource_group_name            = "vmss-${local.spfile.envId}"
  location                       = "westeurope"
  vmss_name                      = "vmss${local.spfile.envId}"
  vnet_name                      = "vmss"
  address_space                  = "10.4.0.0/16"
  subnet_prefixes                = ["10.4.1.0/24", "10.4.2.0/24"]
  backend_lb_IP_address          = 4
  admin_password                 = "Welcome@Home#1984"
  sic_key                        = "welcomehome1984"
  vm_size                        = "Standard_D3_v2"
  disk_size                      = "100"
  vm_os_sku                      = "sg-byol"
  vm_os_offer                    = "check-point-cg-r8120"
  os_version                     = "R8120"
  bootstrap_script               = "touch /tmp/fantomas.was.here" 
  allow_upload_download          = true
  authentication_type            = "Password"
  availability_zones_num         = "1"
  minimum_number_of_vm_instances = 1
  maximum_number_of_vm_instances = 2
  management_name                = "mgmt"
  management_IP                  = ""
  management_interface           = "eth0-public"
  configuration_template_name    = "vmss_template"
  notification_email             = ""
  frontend_load_distribution     = "Default"
  backend_load_distribution      = "Default"
  enable_custom_metrics          = true
  enable_floating_ip             = false
  deployment_mode                = "Standard"
  admin_shell                    = "/bin/bash"
  serial_console_password_hash   = ""
  maintenance_mode_password_hash = ""
  nsg_id                         = ""
  add_storage_account_ip_rules   = false
  storage_account_additional_ips = []
}