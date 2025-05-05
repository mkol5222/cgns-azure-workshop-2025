resource "checkpoint_management_host" "example" {
  name         = "New Host 1"
  ipv4_address = "192.0.2.1"
  color        = "blue"
}

resource "checkpoint_management_host" "pankrac" {
  name         = "pankrac1"
  ipv4_address = "192.0.2.107"
  color        = "red"
}