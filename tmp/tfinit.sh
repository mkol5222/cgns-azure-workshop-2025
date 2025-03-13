#!/bin/bash


ENVID=$(jq -r .envId ../sp.json)
TFSTATE_RG=$(jq -r .TFSTATE_RG ../tfstate.json)
TFSTATE_SA=$(jq -r .TFSTATE_SA ../tfstate.json)
TFSTATE_CONTAINER=$(jq -r .TFSTATE_CONTAINER ../tfstate.json)
TFSTATE_ACCESS_KEY=$(jq -r .TFSTATE_ACCESS_KEY ../tfstate.json)

export ARM_ACCESS_KEY=$TFSTATE_ACCESS_KEY
echo $ARM_ACCESS_KEY

terraform init -reconfigure -upgrade \
  -backend-config=resource_group_name=$TFSTATE_RG \
  -backend-config=storage_account_name=$TFSTATE_SA \
  -backend-config=container_name=$TFSTATE_CONTAINER \
  -backend-config=key=tmp.tfstate

# terraform apply -auto-approve

