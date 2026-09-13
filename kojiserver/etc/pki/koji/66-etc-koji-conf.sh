#!/bin/bash
set -xeuo pipefail
f=/etc/koji.conf
fqdn=`hostname -f`

sed -i.orig 's@^\(server\|weburl\)\( *= *https://\).*\(/koji.*\)@\1\2'"$fqdn"'\3@
     s@^\(topurl *= *https://\).*@\1'"$fqdn"'/kojifiles/@
     s@^\(authtype *= *\).*@\1ssl@
     s@^\;\(cert *= *\)@\1@
     s@^\;\(serverca *= *\)@\1@
     ' $f
diff -u $f{.orig,} || true
httpd -t
exit 0
