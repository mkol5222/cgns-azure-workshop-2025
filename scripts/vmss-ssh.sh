#!/bin/bash

ENVID=$(jq -r .envId sp.json)
RGNAME="vmss-$ENVID"

echo "VMSS resides in RG $RGNAME"


VMSSNAME=$(az vmss list -g $RGNAME -o tsv --query '[0].{name:name}')
echo "VMSSNAME: $VMSSNAME"
IPDATA=$(az vmss  list-instance-public-ips -g $RGNAME -n $VMSSNAME -o json | jq -c .)

FIRST_IP=$(echo $IPDATA | jq -r .[0].ipAddress)
echo "First IP: $FIRST_IP"

VMMS_INDEX=$0


# does sshpass exist?
if ! command -v sshpass &> /dev/null
then
    echo "sshpass could not be found"
    sudo apt update; sudo apt-get -y install sshpass
fi



# if no argument , ssh to FIRST_IP
if [ $# -eq 0 ]; then
  # ssh admin@$FIRST_IP
  sshpass -f <(echo "Welcome@Home#1984") ssh -o "StrictHostKeyChecking no" admin@$FIRST_IP
  exit 0
fi
