#!/bin/bash
set -xeuo pipefail
# allow apache to connect to postgresql
setsebool -P httpd_can_network_connect_db=1
# connect from kojiweb to kojihub
setsebool -P httpd_can_network_connect=1
exit 0
