#!/bin/bash
set -xeuo pipefail

# systemd.resolved by defaults listens globally on port udp/5355
# https://serverfault.com/questions/859038/what-does-the-systemd-resolved-service-do-and-does-it-need-to-listen-on-all-inte
# Disable that:
grep -qE '^LLMNR=no' /etc/systemd/resolved.conf || {
	echo 'LLMNR=no' >> /etc/systemd/resolved.conf
	systemctl restart systemd-resolved
}

# I have no NUMA
dnf remove irqbalance

# PackageKit is bloated daemon that attempts to resolve conflics when
# more than one tool attempts to manage RPMs. On GUI this alow removes
# gnome-software which is good thing...
dnf remove PackageKit

# kexec should be used solely for kernel dumps.
# Someone misuse it for quick reboot which is unreliable
dnf remove kexec-tools

# I have no wifi on Fedora Server
dnf remove iw iwlwifi-*-firmware

# possible privacy risk
dnf remove fprintd fprintd-pam

# I don't use web management
dnf remove cockpit cockpit-\*
# install back useful tools
dnf install jq  openssl NetworkManager-tui

# first install proper editor
dnf install vim-enhanced
# set default editor to vim (will remove nano-default editor):
dnf install --allowerasing vim-default-editor

# Plymouth is here to hide useful boot messages. Who needs that?
dnf remove plymouth plymouth-\*

# fwupd (Firmware Update) is security risk - maintained by single RedHat person
# without proper governance
# See: https://fosspost.org/privacy-security-concern-regarding-gnome-software

dnf remove fwupd fwupd-\*

# geoclue.service contacts mozilla servers on boot to determine your location
# it then reports your location to all programs that apply for it (!)
# See: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=924516
# This spyware is installed on GUI workloads only
systemctl mask geoclue

# nearly 10 packages and lot of services to just generate bug reports for RedHat
dnf remove abrt abrt-\*
# bring back useful packages
dnf install binutils elfutils dracut-squash

# ZRAM (swap compressed RAM to RAM) is CPU hog - chicken and egg nonsense
dnf remove zram-generator zram-generator-defaults

# remove Bluetooth, NIC team and Modem stuff
dnf remove teamd bluez ModemManager NetworkManager-bluetooth NetworkManager-team \
    NetworkManager-wifi wpa_supplicant

echo "OK"
exit 0
