```shell

az vm list-ip-addresses --output table
az vm list-ip-addresses --output json

ENVID=$(jq -r .envId /workspaces/cgns-azure-workshop-2025/sp.json)
RG="cpman-$ENVID"
az vm list-ip-addresses --output table --resource-group $RG

az vm get-instance-view --name <VM_NAME> --resource-group <RESOURCE_GROUP> --query "storageProfile.imageReference" --output table


az serial-console connect --resource-group cpman-3779739a --name cpman

az vm list-ip-addresses --resource-group cpman-3779739a --name cpman --query "[].virtualMachine.network.publicIpAddresses[].ipAddress" --output tsv

CPMAN_IP=$(az vm list-ip-addresses --resource-group cpman-3779739a --name cpman --query "[].virtualMachine.network.publicIpAddresses[].ipAddress" --output tsv)
echo Management IP is $CPMAN_IP

ssh admin@$CPMAN_IP

#cpman ready to connect?
api status | grep 'API readiness test SUCCESSFUL'

