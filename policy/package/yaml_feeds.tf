
locals {
    feeds_file = yamldecode(file("${path.module}/_feeds.yaml"))
    feeds = { for feed in local.feeds_file.feeds : feed.name => feed } 
}

output "feeds" {
    value = local.feeds_file
}

resource "checkpoint_management_network_feed" "yaml_feeds" {
    for_each = local.feeds
  name     = each.key
  feed_url = each.value.url
  #   username = "feed_username"
  #   password = "feed_password"
  feed_format     = "JSON"
  feed_type       = "IP Address"
  update_interval = 60
  json_query      = each.value.jq
}