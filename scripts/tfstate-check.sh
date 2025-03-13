#!/bin/bash

if [ ! -f tfstate.json ]; then
  echo "tfstate.json not found. Run 'make tfstate-up' to create tfstate.json"
  exit 1
fi

if [ ! -f sp.json ]; then
  echo "sp.json not found. Follow instructions in setup.azcli to create sp.json in Azure Shell or locally."
  exit 1
fi

ENVID=$(jq -r .envId sp.json)
TFSTATE_RG=$(jq -r .TFSTATE_RG tfstate.json)
TFSTATE_SA=$(jq -r .TFSTATE_SA tfstate.json)
TFSTATE_CONTAINER=$(jq -r .TFSTATE_CONTAINER tfstate.json)
TFSTATE_ACCESS_KEY=$(jq -r .TFSTATE_ACCESS_KEY tfstate.json)

echo "TFSTATE_RG: $TFSTATE_RG"
echo "TFSTATE_SA: $TFSTATE_SA"
echo "TFSTATE_CONTAINER: $TFSTATE_CONTAINER"

# check if storage account exists
if ! az storage account show --name "${TFSTATE_SA}" --resource-group $TFSTATE_RG > /dev/null; then
  echo "Storage account $TFSTATE_SA not found in resource group $TFSTATE_RG"
  exit 1
fi

az logout

TESTFILE="tfstate-check-$ENVID.txt"
date > "/tmp/$TESTFILE"

# check if we may upload the file
    az storage blob upload \
    --account-name "$TFSTATE_SA" \
    --account-key "$TFSTATE_ACCESS_KEY" \
    --container-name "$TFSTATE_CONTAINER" \
    --name $TESTFILE \
    --file /tmp/$TESTFILE

  # verify the file is downloaded
    az storage blob download \
    --account-name "$TFSTATE_SA" \
    --account-key "$TFSTATE_ACCESS_KEY" \
    --container-name "$TFSTATE_CONTAINER" \
    --name $TESTFILE \
    --file /tmp/downloaded-$TESTFILE

    cat  /tmp/downloaded-$TESTFILE
    diff /tmp/$TESTFILE  /tmp/downloaded-$TESTFILE
    rm /tmp/$TESTFILE  /tmp/downloaded-$TESTFILE

    az storage blob list \
  --account-name "$TFSTATE_SA" \
  --container-name "$TFSTATE_CONTAINER" \
  --auth-mode key --output table --account-key "$TFSTATE_ACCESS_KEY"

az storage blob delete \
  --account-name "$TFSTATE_SA" \
  --account-key "$TFSTATE_ACCESS_KEY" \
  --container-name "$TFSTATE_CONTAINER" \
  --name $TESTFILE

echo "tfstate.json check passed"