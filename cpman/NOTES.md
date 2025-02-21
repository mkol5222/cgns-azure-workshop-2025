```shell

az vm list-ip-addresses --output table
az vm list-ip-addresses --output json

ENVID=$(jq -r .envId /workspaces/cgns-azure-workshop-2025/sp.json)
RG="cpman-$ENVID"
az vm list-ip-addresses --output table --resource-group $RG

az vm get-instance-view --name <VM_NAME> --resource-group <RESOURCE_GROUP> --query "storageProfile.imageReference" --output table