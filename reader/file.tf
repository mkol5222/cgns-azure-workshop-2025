locals {
  reader_creds = jsonencode(
    {
      tenant : local.spfile.tenant,
      subscriptionId : local.spfile.subscriptionId,
      appId : azuread_application.cgns-reader.application_id,
      password : azuread_application_password.cgns-reader-key.value
    }
  )
}

resource "local_file" "reader_creds" {

  content  = local.reader_creds
  filename = "${path.module}/../reader.json"
}

output "file" {
  value = "${path.module}/../reader.json"
}