# locals {
#   cpmanRG  = "cpman-${local.spfile.envId}"
#   cpman_ip = data.azurerm_virtual_machine.cpman.public_ip_address
# }

# data "azurerm_virtual_machine" "cpman" {
#   name                = "cpman"
#   resource_group_name = local.cpmanRG
# }

# # output "cpman_vm" {
# #   value = data.azurerm_virtual_machine.cpman
# # }

# output "cpman_ip" {
#   value = local.cpman_ip
# }

