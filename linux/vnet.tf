
locals {
  linuxRG  = "linux-${local.spfile.envId}"
  location = "West Europe"
}

resource "azurerm_resource_group" "linux" {
  name     = local.linuxRG
  location = local.location
}

resource "azurerm_virtual_network" "linux" {
  name                = "linux"
  location            = azurerm_resource_group.linux.location
  resource_group_name = azurerm_resource_group.linux.name
  address_space       = ["10.114.0.0/16"]

  #   subnet {
  #     name             = "linux"
  #     address_prefixes = ["10.114.1.0/24"]
  #   }
}

// azurerm_subnet.linux-subnet.id
resource "azurerm_subnet" "linux-subnet" {
  name                 = "linux"
  virtual_network_name = azurerm_virtual_network.linux.name
  resource_group_name  = azurerm_resource_group.linux.name
  address_prefixes     = ["10.114.1.0/24"]
}
