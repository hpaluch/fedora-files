#!/bin/bash
set -xeuo pipefail

[ `id -u` -ne 0 ] || {
	echo "ERROR: This script must be run as non-root user" >&2
	exit 1
}
mkdir -p ~/.koji
cp /etc/pki/koji/kojiadmin.pem ~/.koji/client.crt
cp /etc/pki/koji/koji_ca_cert.crt ~/.koji/clientca.crt
cp /etc/pki/koji/koji_ca_cert.crt ~/.koji/serverca.crt
exit 0
