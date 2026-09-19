#!/bin/bash
# Build Henryk's clockres project for Fedora44 using local Koji installation
set -euo pipefail

[ `id -u` -ne 0 ] || { echo "ERROR: This script must be run as regular (non-root) user"'!' >&2; exit 1; }
# note: commit id is latest from branch: koji/master because Koji requires Makefile with
#       'sources' target that builds source tarball from git source
set -x
koji list-pkgs --quiet  --tag dist-f44 | grep -w clockres || {
	# we must add package to distribution - otherwise only --scratch is allowed
	koji add-pkg --owner kojiadmin dist-f44 clockres
}
koji list-pkgs --tag dist-f44
koji build --draft dist-f44 'git+https://github.com/hpaluch-pil/clockres.git#375260459f49346752ff24d0f7ee2acabdddc442'
exit 0
