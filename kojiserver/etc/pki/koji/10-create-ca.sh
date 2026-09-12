#!/bin/bash
set -euo pipefail
fqdn=`hostname -f`
echo "Using FQDN='$fqdn'"
set -x
cd /etc/pki/koji/
mkdir -p {certs,private,confs}
sed -i.orig "/^commonName_default/s/=.*/= $fqdn/" ssl.cnf
diff ssl.cnf{.orig,} || true
touch index.txt
echo 01 > serial
openssl genrsa -out private/koji_ca_cert.key 2048
openssl req -config ssl.cnf -new -x509 -days 3650 -key private/koji_ca_cert.key \
   -out koji_ca_cert.crt -extensions v3_ca
exit 0
