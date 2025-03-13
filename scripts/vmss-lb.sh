#!/bin/bash

ENVID=$(jq -r .envId sp.json)
RGNAME="vmss-$ENVID"

echo "VMSS resides in RG $RGNAME"


VMSSNAME=$(az vmss list -g $RGNAME -o tsv --query '[0].{name:name}')
echo "VMSSNAME: $VMSSNAME"


# az network lb backend-pool show-health --resource-group $RGNAME \
#     --name backend-lb-pool \
#     --lb-name backend-lb


# az vmss get-instance-view --resource-group $RGNAME \
#     --name $VMSSNAME #    --query "virtualMachine.instanceView.statuses[*]"

# fetch LB target metrics


# backend lb id
LBID=$(az network lb list --resource-group $RGNAME -o json | jq -r '.[] | select(.name=="backend-lb") | .id')

az monitor metrics list-definitions --resource $LBID --output table

az monitor metrics list --resource "$LBID" \
    --metric DipAvailability \
    --interval PT1M \
    --aggregation Average \
    --output table

# same per BackendIPAddress
az monitor metrics list --resource "$LBID" \
    --metric DipAvailability \
    --interval PT1M \
    --aggregation Average \
    --filter "BackendIPAddress eq '10.4.2.5'" \
    --output table 

read -p "Press enter to continue"

START_TIME=$(date -u -d "90 minutes ago" +"%Y-%m-%dT%H:%M:%SZ")
END_TIME=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

az monitor metrics list --resource "$LBID" \
    --metric DipAvailability \
    --interval PT1M \
    --aggregation Average \
    --dimension BackendIPAddress \
     --start-time "$START_TIME" \
     --end-time "$END_TIME" \
    --output table

read -p "Press enter to continue"
 az vmss nic list --resource-group $RGNAME \
    --vmss-name $VMSSNAME \
    --output json | jq -r '.[]| select(.name=="eth1") | .ipConfigurations[0].privateIPAddress '

az monitor metrics list --resource "$LBID" \
    --metric DipAvailability \
    --output json | jq '.|keys'

az monitor metrics list-definitions --resource "$LBID" \
    --output json | jq .


echo $LBID
    # .ipConfigurations[0].privateIpAddress
