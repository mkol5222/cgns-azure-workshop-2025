# cgns-azure-workshop-2025
Check Point CloduGuard Network Security (CGNS) Azure workshop

Follow relevant NOTES.md for the workshop

Azure login

```shell
# current state?
az account list -o table
# NOTE: run Codespace in local VScode to take advantage of port-forwarding of login callback from browser

# force local browser login
az login

# if login from Codespace fails, use ./setup.azcli in local Powershell terminal or in https://shell.azure.com/powershell

# we assume sp.json in root of this workspace created above (setup.azcli)
cat /workspaces/cgns-azure-workshop-2025/sp.json

# login using service principal
AZ_TENANTID=$(jq -r .tenant /workspaces/cgns-azure-workshop-2025/sp.json)
AZ_APPID=$(jq -r .appId /workspaces/cgns-azure-workshop-2025/sp.json)
AZ_PASSWORD=$(jq -r .password /workspaces/cgns-azure-workshop-2025/sp.json)
echo $AZ_TENANTID
az login --service-principal \
  --tenant "${AZ_TENANTID}" \
  --username "${AZ_APPID}" \
  --password "${AZ_PASSWORD}"

# current state?
az account list -o table

ENVID=$(jq -r .envId /workspaces/cgns-azure-workshop-2025/sp.json)
echo $ENVID
az group create -g "rg-$ENVID" -l "northeurope"
# delete
az group delete -g "rg-$ENVID" --no-wait --yes
```
