terraform {
  required_providers {
    checkpoint = {
      source  = "checkPointsw/checkpoint"
      #version = "2.9.0"
    }
  }
}

provider "checkpoint" {
     alias = "cp"
  # Configuration options
#   username = var.cpman_admin
#   password = var.cpman_pass
#   server   = local.cpman_ip

  session_name = "terraform"
  session_description = "main"

}

# provider "azurerm" {
#   # Configuration options
#   subscription_id = local.spfile.subscriptionId
#   tenant_id       = local.spfile.tenant
#   client_id       = local.spfile.appId
#   client_secret   = local.spfile.password
#   features {}
# }