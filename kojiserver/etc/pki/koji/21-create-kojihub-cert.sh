#!/bin/bash
set -xeuo pipefail
cd $(dirname 0)

caname=koji
user=kojihub
openssl genrsa -out private/${user}.key 2048
openssl req -config ssl.cnf -new -nodes -out certs/${user}.csr -key private/${user}.key
openssl ca -config ssl.cnf -keyfile private/${caname}_ca_cert.key -cert ${caname}_ca_cert.crt \
    -out certs/${user}.crt -outdir certs -infiles certs/${user}.csr
cat certs/${user}.crt private/${user}.key > ${user}.pem
exit 0
