#!/bin/bash
set -xeuo pipefail

postgresql-setup --initdb --unit postgresql
systemctl enable --now postgresql
useradd koji
passwd koji
exit 0

