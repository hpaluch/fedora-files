#!/bin/bash
set -xeuo pipefail
cd $(dirname 0)
# if you change your certificate authority name to something else you will
# need to change the caname value to reflect the change.
caname=koji

# user is equal to parameter one or the first argument when you actually
# run the script
user=kojira

openssl genrsa -out private/${user}.key 2048

sed "/^commonName_default/s/=.*/= $user/" ssl.cnf > ssl2.cnf
diff -u ssl{,2}.cnf || true
openssl req -config ssl2.cnf -new -nodes -out certs/${user}.csr -key private/${user}.key
openssl ca -config ssl2.cnf -keyfile private/${caname}_ca_cert.key -cert ${caname}_ca_cert.crt \
    -out certs/${user}.crt -outdir certs -infiles certs/${user}.csr
cat certs/${user}.crt private/${user}.key > ${user}.pem
mv ssl2.cnf confs/${user}-ssl.cnf
exit 0
