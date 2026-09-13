#!/bin/bash
set -xeuo pipefail
f=/etc/kojid/kojid.conf
fqdn=`hostname -f`
kojicert=/etc/pki/koji/kojihub.pem
kojica=/etc/pki/koji/koji_ca_cert.crt

sed -i.orig  's@^\(server\|topurl\)\( *= *http://\).*\(/koji.*\)@\1\2'"$fqdn"'\3@
     s@^\(authtype *= *\).*@\1ssl@
     s@^\;\(cert *= *\).*@\1'"$kojicert"'@
     s@^\;\(serverca *= *\).*@\1'"$kojica"'@
     s@^\(allowed_scms *= *\).*@\1'"$fqdn"':/@
     ' $f
diff -u $f{.orig,} || true
exit 0
