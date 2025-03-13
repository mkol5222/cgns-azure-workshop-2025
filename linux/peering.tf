
# there is VMSS vnet in RG vmss-$ENVID

data "azurerm_virtual_network" "vmss" {
  name                = "vmss"
  resource_group_name = "vmss-${local.spfile.envId}"
}

locals {
  create_peering = length(data.azurerm_virtual_network.vmss.id) > 0
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
  remote_virtual_network_id   = data.azurerm_virtual_network.vmss.id
  allow_virtual_network_access = true
}

# from Linux to VMSS
resource "azurerm_virtual_network_peering" "peer_vmss_to_linux" {
  count                       = local.create_peering ? 1 : 0
  name                        = "vmss_to_linux"
  resource_group_name         = data.azurerm_virtual_network.vmss.resource_group_name
  virtual_network_name        = data.azurerm_virtual_network.vmss.name
  remote_virtual_network_id   = azurerm_virtual_network.linux.id
  allow_virtual_network_access = true
}