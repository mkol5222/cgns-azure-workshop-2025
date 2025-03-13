#!/bin/bash

#!/bin/bash

set -euo pipefail

(cd ./linux; terraform apply -var route_through_firewall=true -var nexthop=10.4.2.4)