#!/bin/bash
set -xeuo pipefail
[ `id -u` -ne 0 ] || { echo "ERROR: script must be run as regular user with ~/.koji config" >&2; exit 1; }
koji add-user kojira
koji grant-permission repo kojira
exit 0
