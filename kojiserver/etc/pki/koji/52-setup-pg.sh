#!/bin/bash
set -xeuo pipefail

dnf install koji postgresql
su - koji -c "/usr/sbin/psql koji koji < /usr/share/koji/schema.sql"
exit 0
