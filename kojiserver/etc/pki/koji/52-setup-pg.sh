#!/bin/bash
set -euo pipefail

# allow 'koji' user to connect to postgresql socket
f=/var/lib/pgsql/data/pg_hba.conf
cat <<'EOF' > $f
#TYPE   DATABASE    USER    CIDR-ADDRESS      METHOD
local   koji        koji                       trust
local   all         postgres                   peer
EOF
cat $f

# disable listening on socket (fixme: expects that there is not yet line listen_addresses in conf!)
f=/var/lib/pgsql/data/postgresql.conf

sed "/^listen_addresses/s/=.*/= ''/;t;\$a \\\
listen_addresses = ''" $f > $f.new
diff -u $f $f.new || {
	mv -vf $f $f.old
	mv -v $f.new $f
}

# Just Apache is using default 100 connections - increased to 200
sed 's/^\(max_connections *= *\).*/\1200/' $f > $f.new
diff -u $f $f.new || {
	mv -vf $f $f.old
	mv -v $f.new $f
}
set -x
systemctl restart postgresql

# this command should now succeed
su - koji -c "/usr/sbin/psql -l koji koji"
exit 0
