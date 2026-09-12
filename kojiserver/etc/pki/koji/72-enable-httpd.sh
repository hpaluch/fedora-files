#!/bin/bash
set -xeuo pipefail
systemctl enable --now httpd
exit 0
