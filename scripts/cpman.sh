#!/bin/bash

### build cpman and supply it with policy

set -euo pipefail

# does sp.json exist?
if [ ! -f sp.json ]; then
  echo "sp.json not found. Follow instructions in setup.azcli to create sp.json in Azure Shell or locally."
  exit 1
fi

ACCOUNTSLOGGED=$(az account list -o json | jq -r '.|length')
if [ $ACCOUNTSLOGGED -eq 0 ]; then
  echo "No accounts logged in. Need to login first."
  # am I able to login with it?
  AZ_TENANTID=$(jq -r .tenant sp.json)
  AZ_APPID=$(jq -r .appId sp.json)
  AZ_PASSWORD=$(jq -r .password sp.json)
  AZ_SUBSCRIPTIONID=$(jq -r .subscriptionId sp.json)


  echo "Logging in with SP ${AZ_APPID} in tenant ${AZ_TENANTID}"
  az login --service-principal \
    --tenant "${AZ_TENANTID}" \
    --username "${AZ_APPID}" \
    --password "${AZ_PASSWORD}"

    # current state?
    az account list -o table
fi

ACCOUNTSLOGGED=$(az account list -o json | jq -r '.|length')
if [ $ACCOUNTSLOGGED -eq 0 ]; then
  echo "Login failed. Exiting."
  exit 1
fi

# is there cpman VM and does it have it IP address?
ENVID=$(jq -r .envId sp.json)
RGNAME="cpman-$ENVID"

echo "Checking VM in RG $RGNAME"
CPMAN_IP=$(az vm list-ip-addresses --resource-group "$RGNAME" --name cpman --query "[].virtualMachine.network.publicIpAddresses[].ipAddress" --output tsv)

if [ -z "$CPMAN_IP" ]; then
  echo "No VM found in RG $RGNAME. Deploying."
  # start deployment
    (cd ./cpman; terraform init)
    (cd ./cpman; terraform apply -auto-approve)

    CPMAN_IP=$(az vm list-ip-addresses --resource-group "$RGNAME" --name cpman --query "[].virtualMachine.network.publicIpAddresses[].ipAddress" --output tsv)
    if [ -z "$CPMAN_IP" ]; then
      echo "Failed to deploy cpman VM. Exiting."
      exit 1
    fi
fi

echo Management IP is $CPMAN_IP

while true; do
    echo "Checking if Management API is ready"
    U=admin
    P='Welcome@Home#1984'
    mgmt_server="https://$CPMAN_IP"
    RESP=$(curl -m 3 -ks -X POST $mgmt_server/web_api/login -H 'Content-Type: application/json' -d "{\"user\":\"$U\",\"password\":\"$P\"}")
    # check if resp is valid JSON
    if echo "$RESP" | jq empty >/dev/null 2>&1; then
        echo "Management is responding"
    else
        echo "Management API not ready"
    fi

    echo "checking RESP:"
    echo "==="
    echo "$RESP"
    echo "==="
    sid=$(echo "$RESP" | jq -r '.sid? // "null"' || echo "null")
    if [ "$sid" == "null" ]; then
        echo "Failed to login to Management API. Trying again later."
    else
        echo "Management API is ready"
        break
    fi

    echo "Sleeping for 15 seconds"
    sleep 15
done


