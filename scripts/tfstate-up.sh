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

# create tfstate resource group
az group create --name $TFSTATE_RG --location westeurope

# storage
TFSTATE_SA=cpwstfstate$ENVID
TFSTATE_CONTAINER=tfstate
az storage account create --name $TFSTATE_SA --resource-group $TFSTATE_RG --location westeurope --sku Standard_LRS
az storage container create --name $TFSTATE_CONTAINER --account-name $TFSTATE_SA

ACCOUNT_KEY=$(az storage account keys list --resource-group $TFSTATE_RG --account-name $TFSTATE_SA --query '[0].value' -o tsv)
export ARM_ACCESS_KEY=$ACCOUNT_KEY
# echo "ARM_ACCESS_KEY: $ARM_ACCESS_KEY"

# make JSON tfstat.json in root with TFSTATE_RG, TFSTATE_SA, TFSTATE_CONTAINER, TFSTATE_ACCESS_KEY
cat <<EOF > tfstate.json
{
  "TFSTATE_RG": "$TFSTATE_RG",
  "TFSTATE_SA": "$TFSTATE_SA",
  "TFSTATE_CONTAINER": "$TFSTATE_CONTAINER",
  "TFSTATE_ACCESS_KEY": "$ACCOUNT_KEY"
}
EOF

echo "tfstate.json created"
 