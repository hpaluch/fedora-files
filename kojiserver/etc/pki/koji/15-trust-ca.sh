#!/bin/bash
# copy our Koji CA to system trust store - so curl and friends trust our Koji Webserver
set -xeuo pipefail
set -x
cacert=/etc/pki/koji/koji_ca_cert.crt
cp -v $cacert /etc/pki/ca-trust/source/anchors/
update-ca-trust
exit 0
