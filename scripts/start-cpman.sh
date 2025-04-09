#!/bin/bash

set -euo pipefail

# does sp.json exist?
if [ ! -f sp.json ]; then
  echo "sp.json not found. Follow instructions in setup.azcli to create sp.json in Azure Shell or locally."
  exit 1
fi

ENVID=$(jq -r .envId sp.json)
RGNAME="cpman-$ENVID"

#echo "Logging in to CPMAN in RG $RGNAME"

#CPMAN_IP=$(az vm list-ip-addresses --resource-group "$RGNAME" --name cpman --query "[].virtualMachine.network.publicIpAddresses[].ipAddress" --output tsv)
#echo Management IP is $CPMAN_IP

# start vm
az vm start --resource-group "$RGNAME" --name cpman

