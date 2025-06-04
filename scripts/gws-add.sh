#!/bin/bash

(cd gateways; terraform output -json gateways) | jq -r -c '.[]' | while read -r LINE; do
    echo
    GW=$(echo "$LINE" | jq -r '.name')
    RG=$(echo "$LINE" | jq -r '.rg') 
    # echo "gateway $GW in RG $RG"

    PUBLIC_IP=$(az network public-ip show -g "$RG" -n "$GW" -o json | jq -r .ipAddress)

    ETH0_IP=$(az network nic show -g "$RG" -n "$GW-eth0" -o json | jq  -r '.ipConfigurations[0].privateIPAddress')
    ETH1_IP=$(az network nic show -g "$RG" -n "$GW-eth1" -o json | jq  -r '.ipConfigurations[0].privateIPAddress')
    # tell subnet of NIC eth0
    # az network nic show -g "$RG" -n "$GW-eth0" -o json | jq  -r '.ipConfigurations[0].subnet.id' 
    # tell subnet of NIC eth1
    # az network nic show -g "$RG" -n "$GW-eth1" -o json | jq  -r '.ipConfigurations[0].subnet.id' 
    # tell netmask of NIC eth0
    SUBNET_ETH0_ID=$(az network nic show -g "$RG" -n "$GW-eth0" -o json | jq  -r '.ipConfigurations[0].subnet.id')
    VNETNAME="gw-${GW}-vnet"
    # echo "Subnet eth0: $SUBNET_ETH0_ID" "${SUBNET_ETH0_ID%/*}" "${SUBNET_ETH0_ID##*/}"
    # az network vnet subnet show -g "$RG" --vnet-name "${VNETNAME}" -n "${SUBNET_ETH0_ID##*/}" -o json | jq -r '.addressPrefix | split("/") | .[1]'
    # tell netmask of NIC eth1
    # az network nic show -g "$RG" -n "$GW-eth1" -o json | jq  -r '.ipConfigurations[0].subnet.id'

    cat <<EOF
####
# Add simple GATEWAY to Check Point Management Server
# ${GW} in RG ${RG}

make ssh-cpman

mgmt_cli -r true add host name "localhost" ipv4-address "127.0.0.1" color "blue" ignore-warnings true
  
mgmt_cli -r true \
  add simple-gateway \
  name "${GW}" color "blue" \
  ipv4-address "${PUBLIC_IP}" \
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
  interfaces.1.name "eth0" interfaces.1.ipv4-address "${ETH0_IP}" interfaces.1.ipv4-network-mask "255.255.255.0" interfaces.1.anti-spoofing false interfaces.1.topology "EXTERNAL" \
  interfaces.2.name "eth1" interfaces.2.ipv4-address "${ETH1_IP}" interfaces.2.ipv4-network-mask "255.255.255.0" interfaces.2.anti-spoofing false interfaces.2.topology "INTERNAL"  \
  --format json

mgmt_cli -r true \
  set simple-gateway \
  name "${GW}" \
  identity-awareness-settings.identity-web-api true \
  identity-awareness-settings.identity-web-api-settings.authorized-clients.client "localhost" \
  identity-awareness-settings.identity-web-api-settings.authorized-clients.client-secret "cnienfrfeinueribf" 
#
###
EOF
done