#!/bin/bash

set -euo pipefail

export ENVID=$(jq -r .envId sp.json)
export RGNAME="cpman-$ENVID"
export CPMAN_IP=$(az vm list-ip-addresses --resource-group "$RGNAME" --name cpman --query "[].virtualMachine.network.publicIpAddresses[].ipAddress" --output tsv)

export CHECKPOINT_SERVER="$CPMAN_IP"
export CHECKPOINT_USERNAME="admin"
export CHECKPOINT_PASSWORD="Welcome@Home#1984"

(cd ./policy; terraform destroy -auto-approve)
