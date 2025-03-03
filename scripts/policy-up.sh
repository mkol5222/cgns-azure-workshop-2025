#!/bin/bash

set -euo pipefail

(cd ./policy; terraform init)
(cd ./policy; terraform apply)