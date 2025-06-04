```shell

mgmt_cli -r true delete simple-gateway name "gw10" --format json
mgmt_cli -r true delete simple-gateway name "gw20" --format json

mgmt_cli -r true delete simple-gateway name "ctrl--vmss6aa470f2_0--VMSS-6AA470F2" --format json

mgmt_cli -r true where-used name "gw20" --format json
mgmt_cli -r true where-used name "gw10" --format json
mgmt_cli -r true where-used name "ctrl--vmss6aa470f2_0--VMSS-6AA470F2" --format json | jq .


mgmt_cli -r true show sessions details-level full --format json | jq -r '.objects[].uid' | while read S; do mgmt_cli -r true disconnect uid $S discard true; done

mgmt_cli -r true show sessions details-level full --format json | jq -r '.objects[]|select(.application=="WEB_API")|.uid' | while read S; do mgmt_cli -r true disconnect uid $S discard true; done

mgmt_cli -r true show sessions details-level full --format json | jq -r '.objects[]|select(."user-name"!="admin")|.uid' | while read S; do mgmt_cli -r true disconnect uid $S discard true; done

# provision

mgmt_cli -r true add host name "localhost" ipv4-address "127.0.0.1" color "blue" ignore-warnings true
  
mgmt_cli -r true \
  add simple-gateway \
  name "gw10" color "blue" \
  ipv4-address "52.178.170.31" \
  version "R81.20" \
  one-time-password "welcomehome1984" \
  firewall true vpn false application-control true url-filtering true ips true \
  anti-bot false anti-virus false threat-emulation false \
  nat-hide-internal-interfaces true \
  icap-server false \
  identity-awareness true \
  identity-awareness-settings.identity-collector true \
  identity-awareness-settings.identity-collector-settings.authorized-clients.client localhost \
  identity-awareness-settings.identity-collector-settings.authorized-clients.client-secret "cnienfrfeinueribf" \
  interfaces.1.name "eth0" interfaces.1.ipv4-address "10.91.101.4" interfaces.1.ipv4-network-mask "255.255.255.0" interfaces.1.anti-spoofing false interfaces.1.topology "EXTERNAL" \
  interfaces.2.name "eth1" interfaces.2.ipv4-address "10.91.102.4" interfaces.2.ipv4-network-mask "255.255.255.0" interfaces.2.anti-spoofing false interfaces.2.topology "INTERNAL"  \
  --format json

mgmt_cli -r true \
  add simple-gateway \
  name "gw20" color "blue" \
  ipv4-address "134.149.80.84" \
  version "R81.20" \
  one-time-password "welcomehome1984" \
  firewall true vpn false application-control true url-filtering true ips true \
  anti-bot false anti-virus false threat-emulation false \
  nat-hide-internal-interfaces true \
  icap-server false \
  identity-awareness true \
  identity-awareness-settings.identity-collector true \
  identity-awareness-settings.identity-collector-settings.authorized-clients.client localhost \
  identity-awareness-settings.identity-collector-settings.authorized-clients.client-secret "cnienfrfeinueribf" \
  interfaces.1.name "eth0" interfaces.1.ipv4-address "10.92.101.4" interfaces.1.ipv4-network-mask "255.255.255.0" interfaces.1.anti-spoofing false interfaces.1.topology "EXTERNAL" \
  interfaces.2.name "eth1" interfaces.2.ipv4-address "10.92.102.4" interfaces.2.ipv4-network-mask "255.255.255.0" interfaces.2.anti-spoofing false interfaces.2.topology "INTERNAL"  \
  --format json
  
mgmt_cli -r true \
  set simple-gateway \
  name "gw20" \
  identity-awareness-settings.identity-web-api true \
  identity-awareness-settings.identity-web-api-settings.authorized-clients.client "localhost" \
  identity-awareness-settings.identity-web-api-settings.authorized-clients.client-secret "cnienfrfeinueribf" 

mgmt_cli -r true \
  set simple-gateway \
  name "gw10" \
  identity-awareness-settings.identity-web-api true \
  identity-awareness-settings.identity-web-api-settings.authorized-clients.client "localhost" \
  identity-awareness-settings.identity-web-api-settings.authorized-clients.client-secret "cnienfrfeinueribf" 


  identity-web-api: true
  identity-web-api-settings: 
    authentication-settings: 
      users-directories: 
        internal-users: false
        external-user-profile: false
        users-from-external-directories: "all gateways directories"
        specific: []
    client-access-permissions: 
      portal-web-settings: 
        main-url: "https://0.0.0.0/_IA_API"
        ip-address: "0.0.0.0"
        aliases: []
      accessibility: 
        allow-access-from: "ALL_INTERFACES"
    authorized-clients: 
    - client: "9f10f88b-b15e-45a3-95ab-d99d43c4980a"