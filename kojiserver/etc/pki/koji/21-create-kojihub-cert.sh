#!/bin/bash
set -xeuo pipefail
cd $(dirname 0)

caname=koji
user=kojihub
openssl genrsa -out private/${user}.key 2048
# SAN is required for python3.14 SSL support ('koji' client), otherwise it will mercilessly throw error:
# HTTPSConnectionPool(host='fed-koji.example.com', port=443): Max retries exceeded with url: /kojihub (Caused by SSLError(SSLCertVerificationError(1, "[SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed: Hostname mismatch, certificate is not valid for 'fed-koji.example.com'. (_ssl.c:1082)")))
openssl req -config ssl.cnf -new -nodes -out certs/${user}.csr -key private/${user}.key \
	-addext "subjectAltName = DNS:`hostname -f`"
openssl ca -config ssl.cnf -keyfile private/${caname}_ca_cert.key -cert ${caname}_ca_cert.crt \
	-out certs/${user}.crt -outdir certs -infiles certs/${user}.csr
cat certs/${user}.crt private/${user}.key > ${user}.pem
exit 0
