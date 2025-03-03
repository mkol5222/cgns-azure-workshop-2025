variable "publish" {
  type        = bool
  default     = false
  description = "Set to true to publish changes"
}

resource "checkpoint_management_publish" "policy" {
  count    = var.publish ? 1 : 0
  triggers = ["${timestamp()}"]

  run_publish_on_destroy = true

  depends_on = [
    resource.checkpoint_management_azure_data_center_server.azureDC,
  ]
}