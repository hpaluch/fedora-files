#!/bin/bash
# Build Henryk's clockres project for Fedora44
set -euo pipefail

[ `id -u` -ne 0 ] || { echo "ERROR: This script must be run as regular (non-root) user"'!' >&2; exit 1; }
# note: commit id is latst from branch: rpms/master
#   --scratch --no-rebuild-srpm
#   so far it fails, because it runs 'make sources' that is not supported
set -x

koji build dist-f44 'git+https://github.com/hpaluch-pil/clockres.git#61c23069efba0e0d03deb806443beb2b972fa225'
exit 0
