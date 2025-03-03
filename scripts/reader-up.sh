#!/bin/bash

set -euo pipefail

(cd ./reader; terraform init)
(cd ./reader; terraform apply)