#!/bin/bash

# set -euo pipefail

# cat <(curl -sL https://run.klaud.online/login-sp.sh)

echo "This script is expecting env var. SP to be set with ecrypted credentials. It will use the SP to login to Azure and create sp.json."
echo
# press any key to continue
read -n 1 -s -r -p "Press any key to continue"
echo
source <(curl -sL https://run.klaud.online/login-sp.sh)
echo
echo "SP login complete."
echo
echo "Creating sp.json"
echo "$SPDATA" | jq . > sp.json
cp sp.json reader.json
echo "sp.json created."
echo
