

provider "azurerm" {
  # Configuration options
  subscription_id = local.spfile.subscriptionId
  tenant_id       = local.spfile.tenant
  client_id       = local.spfile.appId
  client_secret   = local.spfile.password
  features {}
}