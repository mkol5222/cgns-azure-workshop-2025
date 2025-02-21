#!/bin/bash

set -euo pipefail

# does sp.json exist?
if [ ! -f sp.json ]; then
  echo "sp.json not found. Follow instructions in setup.azcli to create sp.json in Azure Shell or locally."
  exit 1
fi

ENVID=$(jq -r .envId sp.json)
RGNAME="cpman-$ENVID"

echo "Connecting to SERIAL console of CPMAN in RG $RGNAME"

az serial-console connect --resource-group $RGNAME --name cpman