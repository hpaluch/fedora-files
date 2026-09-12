#!/bin/bash
set -xeuo pipefail
[ `id -u` -ne 0 ] || { echo "ERROR: script must be run as regular user with ~/.koji config" >&2; exit 1; }
koji add-host `hostname -f` i386 x86_64
exit 0
