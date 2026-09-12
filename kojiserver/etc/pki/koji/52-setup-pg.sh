#!/bin/bash
set -xeuo pipefail

# allow 'koji' user to connect to postgresql socket
f=/var/lib/pgsql/data/pg_hba.conf
cat <<'EOF' > $f
#TYPE   DATABASE    USER    CIDR-ADDRESS      METHOD
local   koji        koji                       trust
local   all         postgres                   peer
EOF

# disable listening on socket (fixme: expects that there is not yet line listen_addresses in conf!)
f=/var/lib/pgsql/data/postgresql.conf
line="listen_addresses = ''"
grep "/^$line" $f || echo "$line" >> $f
echo "TODO: Also upper max_connections in $f to at least 200"

systemctl restart postgresql

# this command should now succeed
su - koji -c "/usr/sbin/psql -l koji koji"
exit 0
