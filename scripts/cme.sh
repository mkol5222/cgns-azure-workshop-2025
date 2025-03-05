#!/bin/bash

# get (read-only) credentials to list VMSS in Azure 
CLIENT_ID=$(cat ./reader.json | jq -r .appId)
CLIENT_SECRET=$(cat ./reader.json | jq -r .password)
TENANT_ID=$(cat ./reader.json | jq -r .tenant)
SUBSCRIPTION_ID=$(cat ./reader.json | jq -r .subscriptionId)


ENVID=$(jq -r .envId sp.json)
RGNAME="cpman-$ENVID"
CPMAN_IP=$(az vm list-ip-addresses --resource-group "$RGNAME" --name cpman --query "[].virtualMachine.network.publicIpAddresses[].ipAddress" --output tsv)
echo Management IP is $CPMAN_IP

# configure CME for VMSS - use real credentials!!! (example below is revoked RO Az SP)
# command to run @cpman
echo "Run these commands one by one at cpman SSH prompt." 
echo "  Hint: No need to restart CME after fist command"
echo 
echo
echo autoprov_cfg init Azure -mn mgmt -tn vmss_template -otp welcomehome1984 -ver R81.20 -po Azure -cn ctrl -sb $SUBSCRIPTION_ID -at $TENANT_ID -aci $CLIENT_ID -acs "$CLIENT_SECRET"
echo 
echo autoprov_cfg set template -tn vmss_template -ia -ips
echo
echo "Monitor CME on cpman VM with:"
echo '   tail -f /var/log/CPcme/cme.log'
echo 
echo "Enter cpman CLI using:"
echo "   make ssh-cpman"
echo