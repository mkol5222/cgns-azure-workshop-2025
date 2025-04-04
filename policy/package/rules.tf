resource "checkpoint_management_access_rule" "ssh" {
  layer    = "${checkpoint_management_package.package.name} Network"
  position = { above = checkpoint_management_access_rule.from_net_linux.id }
  #position = { top = "top" }
  name = "allow SSH"

  source = [checkpoint_management_group.groups["gr_trusted"].name]

  enabled = true

  destination        = [checkpoint_management_dynamic_object.LocalGatewayExternal.name, checkpoint_management_dynamic_object.LocalGatewayInternal.name]
  destination_negate = false

  service        = ["ssh"]
  service_negate = false

  action = "Accept"
  action_settings = {
    enable_identity_captive_portal = false
  }

  track = {
    accounting              = false
    alert                   = "none"
    enable_firewall_session = true
    per_connection          = true
    per_session             = true
    type                    = "Log"
  }
}

resource "checkpoint_management_access_rule" "from_net_linux" {
  layer = "${checkpoint_management_package.package.name} Network"
  //position = { above = checkpoint_management_access_rule.rule900.id }
  position = { top = "top" }
  name     = "from Linux subnet"

  source = [checkpoint_management_network.net-linux.name]

  enabled = true

  destination        = ["Any"]
  destination_negate = false

  service        = ["Any"]
  service_negate = false

  action = "Accept"
  action_settings = {
    enable_identity_captive_portal = false
  }

  track = {
    accounting              = false
    alert                   = "none"
    enable_firewall_session = true
    per_connection          = true
    per_session             = true
    type                    = "Log"
  }
}

resource "checkpoint_management_access_rule" "from_feedME" {

  depends_on = [checkpoint_management_azure_data_center_server.azureDC, checkpoint_management_data_center_query.appLinux1]

  layer    = "${checkpoint_management_package.package.name} Network"
  position = { above = checkpoint_management_access_rule.from_net_linux.id }

  name = "from feedME"

  source = [checkpoint_management_network_feed.feedME.name, checkpoint_management_network_feed.quiccloud.name]

  enabled = true

  destination        = ["Any"]
  destination_negate = false

  service        = ["Any"]
  service_negate = false

  action = "Accept"
  action_settings = {
    enable_identity_captive_portal = false
  }

  track = {
    accounting              = false
    alert                   = "none"
    enable_firewall_session = true
    per_connection          = true
    per_session             = true
    type                    = "Log"
  }
}

resource "checkpoint_management_access_rule" "from_dc1_app_linux1" {

  depends_on = [checkpoint_management_azure_data_center_server.azureDC, checkpoint_management_data_center_query.appLinux1]

  layer    = "${checkpoint_management_package.package.name} Network"
  position = { above = checkpoint_management_access_rule.from_net_linux.id }

  name = "from app=linux1"

  source = [checkpoint_management_data_center_query.appLinux1.name]

  enabled = true

  destination        = ["Any"]
  destination_negate = false

  service        = ["Any"]
  service_negate = false

  action = "Accept"
  action_settings = {
    enable_identity_captive_portal = false
  }

  track = {
    accounting              = false
    alert                   = "none"
    enable_firewall_session = true
    per_connection          = true
    per_session             = true
    type                    = "Log"
  }
}

# resource "checkpoint_management_access_rule" "from_net_aks" {
#   layer = "${checkpoint_management_package.package.name} Network"
#   //position = { above = checkpoint_management_access_rule.rule900.id }
#   position = { above = checkpoint_management_access_rule.from_net_linux.id }
#   name     = "from AKS subnet"

#   source = [checkpoint_management_network.net-aks.name]

#   enabled = true

#   destination        = ["Any"]
#   destination_negate = false

#   service        = ["Any"]
#   service_negate = false

#   action = "Accept"
#   action_settings = {
#     enable_identity_captive_portal = false
#   }

#   track = {
#     accounting              = false
#     alert                   = "none"
#     enable_firewall_session = true
#     per_connection          = true
#     per_session             = true
#     type                    = "Log"
#   }
# }

# resource "checkpoint_management_access_rule" "from_deploy_web" {
#   layer = "${checkpoint_management_package.package.name} Network"
#   //position = { above = checkpoint_management_access_rule.rule900.id }
#   position = { above = checkpoint_management_access_rule.from_net_aks.id }
#   name     = "from app=web deployment"

#    source = [checkpoint_management_data_center_query.AksAppWeb.name]

#   enabled = true

#   destination        = ["Any"]
#   destination_negate = false

#   service        = ["Any"]
#   service_negate = false

#   action = "Accept"
#   action_settings = {
#     enable_identity_captive_portal = false
#   }

#   track = {
#     accounting              = false
#     alert                   = "none"
#     enable_firewall_session = true
#     per_connection          = true
#     per_session             = true
#     type                    = "Log"
#   }
# }