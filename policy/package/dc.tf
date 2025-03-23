
locals {
  reader_creds = jsondecode(file("${path.module}/../../reader.json"))
}


resource "checkpoint_management_azure_data_center_server" "azureDC" {
  name                  = "Azure"
  authentication_method = "service-principal-authentication"
  directory_id          = local.reader_creds.tenant
  application_id        = local.reader_creds.appId
  application_key       = local.reader_creds.password

  ignore_warnings = true
}