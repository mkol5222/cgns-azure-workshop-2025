#!/bin/bash

set -euo pipefail

(cd ./cpman; terraform destroy)
