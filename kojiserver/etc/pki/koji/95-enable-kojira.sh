#!/bin/bash
set -xeuo pipefail
systemctl enable --now kojira
sleep 5
cat -v /var/log/kojira.log
exit 0
