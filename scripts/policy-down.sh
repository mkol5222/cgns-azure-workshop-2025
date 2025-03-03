#!/bin/bash

set -euo pipefail

(cd ./policy; terraform destroy)
