data "azuread_client_config" "current" {}

locals {
  spname = "sp-cgnsws-reader-${local.spfile.envId}"
}

resource "azuread_application" "cgns-reader" {
  display_name = local.spname
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_application_password" "cgns-reader-key" {
  display_name          = local.spname
  end_date_relative     = "8640h" # one-year time frame
  application_object_id = azuread_application.cgns-reader.object_id

}

resource "azuread_service_principal" "cgns-reader-sp" {
  client_id = azuread_application.cgns-reader.application_id
  //application_id = azuread_application.cgns-reader.object_id
  owners = [data.azuread_client_config.current.object_id]
}


resource "azurerm_role_assignment" "cgns-reader-role-assign" {

  scope                = "/subscriptions/${local.spfile.subscriptionId}"
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.cgns-reader-sp.object_id
}