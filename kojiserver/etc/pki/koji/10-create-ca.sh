#!/bin/bash
set -xeuo pipefail

cd /etc/pki/koji/
mkdir -p {certs,private,confs}
touch index.txt
echo 01 > serial
openssl genrsa -out private/koji_ca_cert.key 2048
openssl req -config ssl.cnf -new -x509 -days 3650 -key private/koji_ca_cert.key \
   -out koji_ca_cert.crt -extensions v3_ca
exit 0
