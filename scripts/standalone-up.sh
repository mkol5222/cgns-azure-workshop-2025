#!/bin/bash

set -euo pipefail

# does sp.json exist?
if [ ! -f sp.json ]; then
  echo "sp.json not found. Follow instructions in setup.azcli to create sp.json in Azure Shell or locally."
  exit 1
fi

# am I able to login with it?
AZ_TENANTID=$(jq -r .tenant sp.json)
AZ_APPID=$(jq -r .appId sp.json)
AZ_PASSWORD=$(jq -r .password sp.json)
AZ_SUBSCRIPTIONID=$(jq -r .subscriptionId sp.json)

export TF_VAR_client_id="$AZ_APPID"
export TF_VAR_client_secret="$AZ_PASSWORD"
export TF_VAR_subscription_id="$AZ_SUBSCRIPTIONID"
export TF_VAR_tenant_id="$AZ_TENANTID"

(cd ./standalone && terraform init -backend=false)
(cd ./standalone && terraform apply -auto-approve )

