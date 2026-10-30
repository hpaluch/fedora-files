#!/bin/bash
set -xeuo pipefail
cd $( dirname $0 )
su - koji -c "/usr/sbin/psql koji koji -f `pwd`/54-setup-pg.sql"
exit 0
