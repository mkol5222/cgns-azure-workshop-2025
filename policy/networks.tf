resource "checkpoint_management_network" "net-linux" {
  broadcast    = "allow"
  color        = "red"
  mask_length4 = 24
  name         = "net-linux"
  nat_settings = {
    "auto_rule"   = "true"
    "hide_behind" = "gateway"
    "install_on"  = "All"
    "method"      = "hide"
  }
  subnet4 = "10.114.1.0"
  tags    = []
}