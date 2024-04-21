#!/bin/bash
set -xeuo pipefail

# WARNING! Here are optimizations of Fedora Server that may leave your system
# unusable! Use on your own risk!

# gssproxy is needed by NFS/rpcbind. Othwerwise it can be uninstalled:
dnf remove gssproxy

# SSSD is overengineered set of libraries and services to access AD and other stuff
dnf remove sssd sssd-\*

# Now tricky stuff - we have to remove references to that modules (without one 's')
set +x
for i in /etc/pam.d/*
do
	[ -f "$i" ] || continue
	if [[ $i =~ \.bak$ ]];then
		continue
	fi
	if grep -qE '^[^#].*pam_sss\.so' "$i";then
		echo "Commenting out pam_sss.so from $i"
		sed -i.bak -e '/^[^#].*pam_sss\.so/s/^/#/' "$i"
	fi
done
set -x

# PolKit is security disaster, but many apps depends on it
# See https://github.blog/2021-06-10-privilege-escalation-polkit-root-on-linux-with-bug/
dnf remove polkit
echo "OK"
exit 0
