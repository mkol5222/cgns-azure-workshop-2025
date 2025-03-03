#!/bin/bash

set -euo pipefail

(cd ./linux; terraform destroy)
