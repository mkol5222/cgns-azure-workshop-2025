resource "null_resource" "example" {
  provisioner "local-exec" {
    command = "echo 'Hello from Terraform!'"
  }
}

resource "random_pet" "pet" {
  length = 2
}

terraform {
  backend "azurerm" {}
}