#!/bin/bash
set -xeuo pipefail

# install back useful tools
dnf install jq openssl NetworkManager-tui git-lfs

# first install proper editor
dnf install vim-enhanced
# set default editor to vim (will remove nano-default editor):
dnf install --allowerasing vim-default-editor

echo "OK"
exit 0
