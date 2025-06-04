# template of add-simple-gateway commands

locals {
  name        = "Alice"
  environment = "production"

    command = templatefile("${path.module}/commands.tpl", {
      name        = local.name
      environment = local.environment
    })
}

output "commands" {
    value = local.command
}

