#!/bin/bash
set -xeuo pipefail

mkdir -p /mnt/koji
cd /mnt/koji
mkdir -p {packages,repos,work,scratch,repos-dist}
chown apache:apache *

setsebool -P allow_httpd_anon_write=1
semanage fcontext -a -t public_content_rw_t "/mnt/koji(/.*)?"
restorecon -r -v /mnt/koji

exit 0
