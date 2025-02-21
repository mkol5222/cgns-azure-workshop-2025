# cgns-azure-workshop-2025
Check Point CloduGuard Network Security (CGNS) Azure workshop

### Steps

1. Create a service principal (sp.json) in Azure Cloud Shell based on commands in ./setup.azcli
JSON data structure for `sp.json` is shown at the end.

2. Create file `sp.json` under `/workspaces/cgns-azure-workshop-2025` in JSON format from Azure Shell SP creation process above.

3. Check SP is valid by running
`make check-sp`

It will look for `sp.json`, try to login Azure CLI using the SP, and list the subscriptions.
It will also create and delete test resouce group.

4. Deploy Check Point Management Server using Terraform
`make cpman-up`
It is using Check Point terraform module for Management Server into new VNET 
and is authenticated using the SP in `sp.json`.
