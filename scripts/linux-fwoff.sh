#!/bin/bash

#!/bin/bash

set -euo pipefail

(cd ./linux; terraform apply -var route_through_firewall=false)