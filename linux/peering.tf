
# there is VMSS vnet in RG vmss-$ENVID

# data "azurerm_virtual_network" "vmss" {
#   name                = "vmss"
#   resource_group_name = "vmss-${local.spfile.envId}"
# }

# get token for AzureRM api calls
data "azurerm_client_config" "current" {}

locals {
  // token = data.azurerm_client_config.current.access_token
}


  # subscription_id = local.spfile.subscriptionId
  # tenant_id       = local.spfile.tenant
  # client_id       = local.spfile.appId
  # client_secret   = local.spfile.password

data "http" "access_token" {
  method = "POST"
  url    = "https://login.microsoftonline.com/${local.spfile.tenant}/oauth2/v2.0/token"

  request_headers = {
    Content-Type = "application/x-www-form-urlencoded"
  }

  request_body = "grant_type=client_credentials&client_id=${local.spfile.appId}&client_secret=${local.spfile.password}&scope=https://management.azure.com/.default"
}

locals {
  token = jsondecode(data.http.access_token.body).access_token
}


# output "token" {
#   value = local.token
# }


# get the vnet id of vmss vnet using API call
data "http" "vmss_vnet" {
  url = "https://management.azure.com/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/vmss-${local.spfile.envId}/providers/Microsoft.Network/virtualNetworks/vmss?api-version=2020-11-01"
  request_headers = {
    Authorization = "Bearer ${local.token}"
  }
}

# extract VMSS ID from the response
locals {
  vnet_resp_body = jsondecode(data.http.vmss_vnet.body)
  vnet_resp_error = try(local.vnet_resp_body.error, null) != null ? true : false
  vmss_vnet_id = local.vnet_resp_error ? null : local.vnet_resp_body.id
  vmss_vnet_name = local.vnet_resp_error ? null : local.vnet_resp_body.name
  vmss_vnet_rg = "vmss-${local.spfile.envId}"
}

output "vnet_resp_body" {
  value = local.vnet_resp_body
}

output "vmss_vnet_id" {
  value = local.vmss_vnet_id
}

# check if peering is needed





locals {
  #vmss_vnet_id = try(data.azurerm_virtual_network.vmss.id, null)
  create_peering = !local.vnet_resp_error
}

output "create_peering" {
  value       = local.create_peering
}

# from VMSS to Linux
resource "azurerm_virtual_network_peering" "peer_linux_to_vmss" {
  count                       = local.create_peering ? 1 : 0
  name                        = "linux_to_vmss"
  resource_group_name         = azurerm_resource_group.linux.name
  virtual_network_name        = azurerm_virtual_network.linux.name
  remote_virtual_network_id   = local.vmss_vnet_id
  allow_virtual_network_access = true
}

# from Linux to VMSS
resource "azurerm_virtual_network_peering" "peer_vmss_to_linux" {
  count                       = local.create_peering ? 1 : 0
  name                        = "vmss_to_linux"
  resource_group_name         = local.vmss_vnet_rg
  virtual_network_name        = local.vmss_vnet_name
  remote_virtual_network_id   = azurerm_virtual_network.linux.id
  allow_virtual_network_access = true
}