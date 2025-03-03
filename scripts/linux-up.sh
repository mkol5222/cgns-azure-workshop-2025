#!/bin/bash

set -euo pipefail

(cd ./linux; terraform init)
(cd ./linux; terraform apply)