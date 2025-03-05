#!/bin/bash

ENVID=$(jq -r .envId sp.json)
RGNAME="vmss-$ENVID"

echo "VMSS resides in RG $RGNAME"


VMSSNAME=$(az vmss list -g $RGNAME -o tsv --query '[0].{name:name}')
echo "VMSSNAME: $VMSSNAME"
az vmss  list-instance-public-ips -g $RGNAME -n $VMSSNAME -o table
