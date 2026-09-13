#!/bin/bash
set -xeuo pipefail
f=/etc/koji-hub/hub.conf
sed -i.orig 's/^# *\(DNUsernameComponent.*\)/\1/
s!^# \(ProxyDNs *= *\).*!\1/C=AT/ST=Vienna/O=My company/CN=example/emailAddress=root@example.com!
s@^\(KojiWebURL *= *\).*@\1http://'"`hostname -f`"'/koji@' $f
diff -u $f{.orig,} || true
httpd -t
exit 0
