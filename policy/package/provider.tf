terraform {
  required_providers {
    checkpoint = {
      source  = "CheckPointSW/checkpoint"
      version = "2.9.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  subscription_id = local.spfile.subscriptionId
  tenant_id       = local.spfile.tenant
  client_id       = local.spfile.appId
  client_secret   = local.spfile.password
  features {}
}

provider "checkpoint" {
  # Configuration options
  username = var.cpman_admin
  password = var.cpman_pass
  server   = var.cpman_ip
  sesion_timeout = 60
  session_name = "terraform"
  session_description = "policy package"

}