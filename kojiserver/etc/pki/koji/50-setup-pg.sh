#!/bin/bash
set -xeuo pipefail
dnf install postgresql-server
postgresql-setup --initdb --unit postgresql
systemctl enable --now postgresql
useradd koji
passwd koji
exit 0

