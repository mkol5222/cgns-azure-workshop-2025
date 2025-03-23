#!/bin/bash

set -euo pipefail

(cd ./reader; terraform destroy -var publish=true)
