locals {
  spfile = jsondecode(file("${path.module}/../../sp.json"))
}