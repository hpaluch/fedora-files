#!/bin/bash
# setup readable console fonts instead of default
# unreadable tiny flea characters
set -euo pipefail

p=console-setup
set -x
rpm -q $p || sudo dnf install $p
set +x

svc_installed=0

for i in /etc/default/console-setup /etc/systemd/system/console-font.service
do
	n="$(basename $i)"
	if [ -f "$i" ]; then
		diff -u $n $i || {
			echo -n "Files $n -> $i have different content, overwrite [y/N]? "
			read ans
			case "$ans" in
				[yY]|[yY][eE][sS])
					sudo cp -v $n $i
					[ "$n" != console-font.service ] || svc_installed=1
					;;
				*)
					echo "Skipped - no change made"
					;;
			esac
		}
	else
		sudo cp -v $n $i
		[ "$n" != console-font.service ] || svc_installed=1
	fi
done
if [ $svc_installed -eq 1 ];then
	echo "Installed new service - reloading and enabling..."
	sudo systemctl daemon-reload
	sudo systemctl enable console-font.service
fi

exit 0
