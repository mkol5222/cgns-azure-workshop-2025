variable "publish" {
  type        = bool
  default     = false
  description = "Set to true to publish changes"
}

locals {
  publish_triggers = [for filename in fileset(path.module, "package/*.tf") : filesha256(filename)]
}

# Make the publish resources dependent of the module and trigger it if there is a change in the configuration files
resource "checkpoint_management_publish" "publish" {
  depends_on = [module.package]
  triggers   = local.publish_triggers

}


resource "checkpoint_management_publish" "policy" {
  count    = var.publish ? 1 : 0
  triggers = local.publish_triggers //["${timestamp()}"]

  run_publish_on_destroy = true

  # depends_on = [
  #   resource.checkpoint_management_azure_data_center_server.azureDC,
  # ]
}