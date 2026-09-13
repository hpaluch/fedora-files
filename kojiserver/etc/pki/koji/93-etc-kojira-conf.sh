#!/bin/bash
set -xeuo pipefail
f=/etc/kojira/kojira.conf
fqdn=`hostname -f`
kojicert=/etc/pki/koji/kojira.pem
kojica=/etc/pki/koji/koji_ca_cert.crt

sed -i.orig  's@^\(server\)\( *= *http://\).*\(/koji.*\)@\1\2'"$fqdn"'\3@
     s@^\;\(cert *= *\).*@\1'"$kojicert"'@
     s@^\;\(serverca *= *\).*@\1'"$kojica"'@
     ' $f
diff -u $f{.orig,} || true
exit 0
