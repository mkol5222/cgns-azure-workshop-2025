#!/bin/bash

set -euo pipefail

# does sp.json exist?
if [ ! -f sp.json ]; then
  echo "sp.json not found. Follow instructions in setup.azcli to create sp.json in Azure Shell or locally."
  exit 1
fi

# isAZ CLI logged in?
if ! az account show > /dev/null; then
  echo "Please login to Azure CLI using 'make check-sp'"
  exit 1
fi

ENVID=$(jq -r .envId sp.json)
echo "ENVID: $ENVID"
TFSTATE_RG="tfstate-$ENVID"

# does RG exist?
if ! az group show --name $TFSTATE_RG > /dev/null; then
  echo "Resource group $TFSTATE_RG not found. Run 'make tfstate-up' to create tfstate.json"
  exit 1
fi

# remove whole resource group
az group delete --name $TFSTATE_RG 