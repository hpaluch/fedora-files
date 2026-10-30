#!/bin/bash
# setup installed Fedora Rawhide for CLI usage. It was tested when "Server" profile was installed.
# WARNING!
# WARNING! Opinionated - USE ON YOUR OWN RISK!
# WARNING!
set -euo pipefail
errx () { echo "ERROR: $*" >&2; exit 1; }
d=$( readlink -f $( dirname $0 ))
[ -d "$d" ] || errx "Internal error - inferred script path '$d' is not directory"
echo "INFO: This script location='$d'"
sd=
[ `id -u` -eq 0 ] || sd="sudo "

set -x
# first, install proper editor and make it default
p=vim-default-editor 
rpm -q $p || ${sd}dnf install -y --allowerasing $p
f=/etc/vimrc.local
[ -f "$f" ] || {
	echo "set background=dark" | ${sd}tee $f
}

# limit number of installed kernels to 2 (default is 3)
f=/etc/dnf/dnf.conf
grep -q '^installonly_limit' $f || {
	echo "installonly_limit=2" | ${sd}tee -a $f
	${sd}dnf upgrade # force removal of extra kernels
}

# remove various bloat
for i in bluez-libs avahi-libs fpaste fprintd fprintd-pam bat wpa_supplicant \
       	deltarpm microcode_ctl gssproxy irqbalance iw teamd sos gsettings-desktop-schemas
do
	if rpm -q $i 2> /dev/null; then
		${sd}dnf remove $i
	fi
done
# some bloat requires wildcard removal (no rpm)
${sd}dnf remove cockpit-'*' fwupd fwupd-'*' google-noto-'*' iwl'*' \
       	ModemManager'*' PackageKit'*' plymouth'*' zram-'*' whois'*' sssd-'*' \
        ntfs'*'
# be careful these are tricky
${sd}dnf remove polkit polkit-'*'

# under Hypervisor kernel firmware is not needed (most of time).
rpm -q virt-what || ${sd}dnf install -y virt-what
[ -z `${sd}virt-what` ] || ${sd}dnf remove '*'-firmware-'*' b43-'*' alsa-sof-firmware

# install useful tools - last step - because dnf remove could remove some of them
p="jq openssl NetworkManager-tui git-lfs git-core tmux net-tools bind-utils mc ncdu btop fastfetch"
rpm -q $p || ${sd}dnf install -y $p

# disable sleep if possible
f=/etc/systemd/sleep.conf
[ -f "$f" ] || {
cat <<'EOF' | ${sd}tee $f
[Sleep]
AllowSuspend=no
AllowHibernation=no
AllowSuspendThenHibernate=no
AllowHybridSleep=no
#SuspendState=mem standby freeze
#HibernateMode=platform shutdown
#MemorySleepMode=
#HibernateDelaySec=
HibernateOnACPower=no
#SuspendEstimationSec=60min
EOF
}


# global grub parameters to remove
# note: resume_arg could be empty (if already removed)
resume_arg=$( grep -o '\bresume=[^ ]*' /etc/kernel/cmdline || true )
for i in quiet rhgb $resume_arg
do
	if grep '\b'"$i"'\b' /etc/kernel/cmdline;then
		${sd}grubby --update-kernel=ALL --remove-args=$i
	fi
done
# clone my repos that contains scripts to be installed
for i in hpaluch-pil/linux-scripts hpaluch-pil/pil-git-scripts
do
	td=~/projects/github.com/$i
	bd=$(dirname $td)
	[ -d "$td" ] || {
		git clone -C $bd https://github.com/$i
	}
done
[ -x /usr/local/bin/push_branch.sh ] || ${sd}cp -v ~/projects/github.com/hpaluch-pil/pil-git-scripts/scripts/*.sh /usr/local/bin
[ -x /usr/local/bin/cz_to_ascii.sh ] || ${sd}cp -v ~/projects/github.com/hpaluch-pil/linux-scripts/{git,non-ascii}/*.sh /usr/local/bin

if grep -q '\bbtrfs\b' /proc/mounts; then
	[ -x /usr/local/sbin/btrfs-balance.sh ] || ${sd}cp -v ~/projects/github.com/hpaluch-pil/linux-scripts/btrfs/*.sh /usr/local/sbin
fi

# run script for NM privacy if needed
[ -f /etc/NetworkManager/conf.d/60-ip6-privacy.conf ] || ~/projects/github.com/hpaluch-pil/linux-scripts/network-manager/nm-privacy.sh

echo "OK"
exit 0
