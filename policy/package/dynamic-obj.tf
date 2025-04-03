

    # LocalGatewayExternal

    # LocalGatewayInternal

resource "checkpoint_management_dynamic_object" "LocalGatewayExternal" {
  name = "LocalGatewayExternal"
  comments = "used by VMSS"
  color = "red"
}

resource "checkpoint_management_dynamic_object" "LocalGatewayInternal" {
  name = "LocalGatewayInternal"
  comments = "used by VMSS"
  color = "blue"
}
