resource "checkpoint_management_network_feed" "feedME" {
  name = "feedME"
  feed_url = "https://feed-serv.deno.dev/ip"
#   username = "feed_username"
#   password = "feed_password"
  feed_format = "JSON"
  feed_type = "IP Address"
  update_interval = 60
   json_query = ".[]|.ip"
}

// https://quic.cloud/ips

resource "checkpoint_management_network_feed" "quic" {
  name = "quic"
  feed_url = "https://quic.cloud/ips"
#   username = "feed_username"
#   password = "feed_password"
  feed_format = "Flat List" 
  feed_type = "IP Address"
  update_interval = 60
}
