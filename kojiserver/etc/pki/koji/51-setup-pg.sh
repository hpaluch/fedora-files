#!/bin/bash
set -xeuo pipefail

u=postgres
[ `id -un` = "$u" ] || { echo "ERROR: script must be run as user '$u' but you are '`id  -un`'" >&2; exit 1; }

createuser --no-superuser --no-createrole --no-createdb koji
createdb -O koji koji
psql -c "alter user koji with encrypted password 'asdf1234';"

exit 0
