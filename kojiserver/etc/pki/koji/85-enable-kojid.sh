#!/bin/bash
set -xeuo pipefail
systemctl enable --now kojid
sleep 5
cat -v /var/log/kojid.log
exit 0
