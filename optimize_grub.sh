#!/bin/bash
set -xeuo pipefail
# Optimize grub settings on Fedora Server

# NOTE: If you are using BIOS you mee need to reinstall grubyy (GRUB BIOS wrapper) instead
# of sdubby (GRUB EFI wrapper)
# see: https://bugzilla.redhat.com/show_bug.cgi?id=2243872

if rpm -q sdubby;then
  echo "On BIOS use: 'dnf install --allowerasing grubby' to fix grubby"
fi

# restore console messages
grubby --update-kernel=ALL --remove-args=rhgb
grubby --update-kernel=ALL --remove-args=quiet

cat <<EOF
Here are some examples:

# find UUID in /boot/loader/entries/*.conf
grubby --update-kernel=ALL --remove-args=resume=XXXXXX
grubby --update-kernel=ALL --args=noresume
# give back normal CPU peformance (mitigations are killing old CPUs)
grubby --update-kernel=ALL --args=mitigations=off
# text console is enough on server
grubby --update-kernel=ALL --args=nomodeset
# stop rename of interfaces - WARNING! you wil have to change
# files in /etc/NetworkManager/system-connections/ !!!
grubby --update-kernel=ALL --args=net.ifnames=0
EOF

exit 0
