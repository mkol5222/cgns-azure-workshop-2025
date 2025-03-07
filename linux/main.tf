resource "azurerm_public_ip" "public_ip" {
  name                = "${var.vm_name}-pip"
  location            = azurerm_resource_group.linux.location
  resource_group_name = azurerm_resource_group.linux.name
  allocation_method   = "Static"


  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
    ]
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.vm_name}-ngs"
  location            = azurerm_resource_group.linux.location
  resource_group_name = azurerm_resource_group.linux.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
    ]
  }
}

resource "azurerm_network_interface" "nic" {
  depends_on = [
    azurerm_subnet.linux-subnet
  ]
  name                = "${var.vm_name}-nic"
  location            = azurerm_resource_group.linux.location
  resource_group_name = azurerm_resource_group.linux.name

  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = azurerm_subnet.linux-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
    ]
  }

}

resource "azurerm_network_interface_security_group_association" "association" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    # resource_group = data.azurerm_resource_group.rg.name
    vm_name = var.vm_name
  }

  byte_length = 8
}

resource "azurerm_storage_account" "storage" {
  name                     = "diag${random_id.randomId.hex}"
  location                 = azurerm_resource_group.linux.location
  resource_group_name      = azurerm_resource_group.linux.name
  account_tier             = "Standard"
  account_replication_type = "LRS"

  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
    ]
  }

}

resource "tls_private_key" "linux_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096

}

resource "azurerm_linux_virtual_machine" "linuxvm" {
  name                  = var.vm_name
  location              = azurerm_resource_group.linux.location
  resource_group_name   = azurerm_resource_group.linux.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "${var.vm_name}-myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    # publisher = "Canonical"
    # offer     = "UbuntuServer"
    # sku       = "18.04-LTS"

    publisher = "Canonical"
    offer = "0001-com-ubuntu-server-jammy"
    sku = "22_04-lts"
    version   = "latest"
  }

  computer_name                   = var.vm_name
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.linux_ssh.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.storage.primary_blob_endpoint
  }
  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
    ]
  }

  tags = {
    app = "linux1"
  }

}

resource "azurerm_route_table" "linux-rt" {
  name                = "linux-rt-tf"
  location            = azurerm_resource_group.linux.location
  resource_group_name = azurerm_resource_group.linux.name
  #disable_bgp_route_propagation = false


  #   route {
  #     name                   = "to-aks"
  #     address_prefix         = "10.68.1.0/24"
  #     next_hop_type          = "VirtualAppliance"
  #     next_hop_in_ip_address = "10.68.11.4"
  #   }

  route {
    name           = "route-to-my-pub-ip"
    address_prefix = "${data.http.myip.response_body}/32"
    next_hop_type  = "Internet"
  }

  dynamic "route" {
    for_each = var.route_through_firewall ? [] : [1]
    content {
      name           = "to-internet"
      address_prefix = "0.0.0.0/0"
      next_hop_type  = "Internet"
    }
  }
  dynamic "route" {
    for_each = var.route_through_firewall ? [1] : []
    content {
      name                   = "to-internet"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = var.nexthop
    }
  }

  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
    ]
  }
}

resource "azurerm_subnet_route_table_association" "linux-rt-to-subnet" {
  subnet_id      = azurerm_subnet.linux-subnet.id
  route_table_id = azurerm_route_table.linux-rt.id
}