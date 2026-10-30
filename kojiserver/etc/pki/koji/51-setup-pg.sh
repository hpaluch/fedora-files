#!/bin/bash
set -euo pipefail

sd=
u=postgres
[ `id -un` = "$u" ] || sd="sudo -u $u -i "

set -x
${sd}createuser --no-superuser --no-createrole --no-createdb koji
${sd}createdb -O koji koji
${sd}psql -c "alter user koji with encrypted password 'asdf1234';"
exit 0
