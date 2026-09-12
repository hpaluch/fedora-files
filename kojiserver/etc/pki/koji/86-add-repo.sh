#!/bin/bash
set -xeuo pipefail
[ `id -u` -ne 0 ] || { echo "ERROR: script must be run as regular user with ~/.koji config" >&2; exit 1; }
koji add-host-to-channel `hostname -f` createrepo
exit 0
