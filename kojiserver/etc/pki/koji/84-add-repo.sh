#!/bin/bash
set -xeuo pipefail
[ `id -u` -ne 0 ] || { echo "ERROR: script must be run as regular user with ~/.koji config" >&2; exit 1; }
# WARNING! This must be run BEFORE enabling "kojid" service, because it requires 
# single exclusive session - leading to [ERROR] koji: AuthLockError: User locked by another session
koji add-host-to-channel `hostname -f` createrepo
exit 0
