terraform {

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.48.0"
    }
  }
}

provider "azuread" {
  # Configuration options
  tenant_id     = local.spfile.tenant
  client_id     = local.spfile.appId
  client_secret = local.spfile.password


}

provider "azurerm" {
  # Configuration options
  subscription_id = local.spfile.subscriptionId
  tenant_id       = local.spfile.tenant
  client_id       = local.spfile.appId
  client_secret   = local.spfile.password
  features {}
}