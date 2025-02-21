#!/bin/bash

set -euo pipefail

# does sp.json exist?
if [ ! -f sp.json ]; then
  echo "sp.json not found. Follow instructions iun setup.azcli to create sp.json in Azure Shell or locally."
  exit 1
fi

# am I able to login with it?
AZ_TENANTID=$(jq -r .tenant sp.json)
AZ_APPID=$(jq -r .appId sp.json)
AZ_PASSWORD=$(jq -r .password sp.json)

echo "Logging in with SP ${AZ_APPID} in tenant ${AZ_TENANTID}"
az login --service-principal \
  --tenant "${AZ_TENANTID}" \
  --username "${AZ_APPID}" \
  --password "${AZ_PASSWORD}"

# current state?
az account list -o table

# able to create RG?
ENVID=$(jq -r .envId sp.json)
echo "ENVID: $ENVID"
RGNAME="rg-test-$ENVID"

echo "Creating RG $RGNAME"
az group create --name $RGNAME --location westeurope

echo "Deleting RG $RGNAME"
az group delete --name $RGNAME --yes
