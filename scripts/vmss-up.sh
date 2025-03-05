#!/bin/bash

set -euo pipefail

(cd ./vmss; terraform init)
(cd ./vmss; terraform apply)