

locals {
    objects = yamldecode(file("${path.module}/_objects.yaml"))

    # make array of objects into a map to iterate   
    networks = { for network in local.objects.networks : network.name => network }
    hosts = { for host in local.objects.hosts : host.name => host }
    
    # iterate all objects and make sum of all groups, then make list set - only unique values
    groups_n = distinct([for network in local.objects.networks : network.groups] )
    groups_h = distinct([for host in local.objects.hosts : host.groups] )
    groups = distinct(concat(flatten(local.groups_n), flatten(local.groups_h)))

group_members_n = { 
  for group in local.groups : 
  group => [for network in local.objects.networks : network.name if contains(network.groups, group)] 
}

group_members_h = { 
  for group in local.groups : 
  // filter all hosts that are in the group
    group => [for host in local.objects.hosts : host.name if contains(host.groups, group)]
}


group_members = {
  for group in local.groups : 
  group => concat(
    lookup(local.group_members_n, group, []),
    lookup(local.group_members_h, group, [])
  )
}
}

resource "checkpoint_management_group" "groups" {
    depends_on = [checkpoint_management_host.yaml_hosts, checkpoint_management_network.yaml_networks]
    for_each = local.group_members
  name = each.key
  members = each.value
  tags = ["terraform"]
    color = "pink"
}

output "objects" {
    value = local.objects
}

output "groups" {
    value = local.groups
}

output "group_members" {
    value = local.group_members
}

output "group_members_n" {
    value = local.group_members_n
}
output "group_members_h" {
    value = local.group_members_h
}

# iterate all networks in local.objects.networks

resource "checkpoint_management_network" "yaml_networks" {
    
    for_each = local.networks
    name = each.value.name
    subnet4 = split("/", each.value.subnet)[0]
    mask_length4 = split( "/", each.value.subnet)[1]
    color = each.value.color
    comments = "made by terraform"
    tags = each.value.tags
}

resource "checkpoint_management_host" "yaml_hosts" {
    for_each = local.hosts
  name = each.value.name
  ipv4_address = each.value.ipv4_address
      color = each.value.color
    comments = "made by terraform"
    tags = each.value.tags
}

# networks:
#   - name: net_windows7
#     subnet: 10.0.10.0/24
#     color: pink
#     tags:
#       - windows
#       - windows7
#     groups:
#      - gr_net_win 
#   - name: net_windows10
#     subnet: 10.10.10.0/24
#     color: blue
#     tags:
#       - windows
#       - windows10
#     groups:
#       - gr_net_win
# hosts:
#   - name: ubuntu2204
#     ipv4_address: 10.10.177.177
#     color: red
#     tags:
#       - ubuntu
#       - ubuntu2204
#     groups:
#       - gr_linux
