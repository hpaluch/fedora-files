#!/bin/bash
set -xeuo pipefail
firewall-cmd --set-log-denied=unicast
firewall-cmd --permanent --zone=FedoraServer --add-service=http
firewall-cmd --permanent --zone=FedoraServer --add-service=https
firewall-cmd --reload
exit 0
