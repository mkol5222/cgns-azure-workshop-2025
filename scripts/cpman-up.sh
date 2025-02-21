#!/bin/bash

set -euo pipefail

(cd ./cpman; terraform init)
(cd ./cpman; terraform apply)