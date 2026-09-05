#!/bin/bash
set -xeuo pipefail
cd $(dirname $0)

user=kojiadmin
caname=koji
openssl pkcs12 -export -inkey private/${user}.key -in certs/${user}.crt \
	-CAfile ${caname}_ca_cert.crt -out certs/${user}_browser_cert.p12
exit 0
