#!/bin/bash

#!/bin/bash

ENVID=$(jq -r .envId sp.json)
RGNAME="linux-$ENVID"

# echo "Linux resides in RG $RGNAME"


az network route-table route list -g $RGNAME --route-table-name linux-rt-tf --output table