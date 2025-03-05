#!/bin/bash

set -euo pipefail

(cd ./vmss; terraform destroy)
