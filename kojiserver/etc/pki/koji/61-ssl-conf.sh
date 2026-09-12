#!/bin/bash
# setup Apache SSL conf to use our certificates
set -xeuo pipefail
f=/etc/httpd/conf.d/ssl.conf
sed -i.orig '/^SSLCertificateFile.*localhost.crt$/,/SSLCertificateKeyFile.*localhost/c \
SSLCertificateFile /etc/pki/koji/certs/kojihub.crt \
SSLCertificateKeyFile /etc/pki/koji/private/kojihub.key \
SSLCertificateChainFile /etc/pki/koji/koji_ca_cert.crt \
SSLCACertificateFile /etc/pki/koji/koji_ca_cert.crt' $f
diff -u $f{.orig,} || true
httpd -t
exit 0
