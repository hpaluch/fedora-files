#!/bin/bash
set -xeuo pipefail
f=/etc/kojiweb/web.conf
fqdn=`hostname -f`
kojicert=/etc/pki/koji/certs/kojiadmin.crt

#kojica=/etc/pki/koji/koji_ca_cert.crt
# s@^\(# \)*\(KojiHubCA *= *\).*@\2'"$kojica"'@' 

sed -i.orig 's@^\(Koji.*URL *= *http://\).*\(/koji.*\)@\1'"$fqdn"'\2@
     s@^\(# \)*\(WebCert *= *\).*@\2'"$kojicert"'@' $f
diff -u $f{.orig,} || true
httpd -t
exit 0
