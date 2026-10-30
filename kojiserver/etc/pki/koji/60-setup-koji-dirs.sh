#!/bin/bash
set -xeuo pipefail
# Fedora 45: install semanage command via policycoreutils-python-utils
dnf install -y koji-hub koji-web mod_ssl python3-jinja2 policycoreutils-python-utils
# add simple landing page
echo 'Go to <a href="/koji/">/koji/</a>' > /var/www/html/index.html
mkdir -p /mnt/koji
cd /mnt/koji
mkdir -p {packages,repos,work,scratch,repos-dist}
chown apache:apache *

setsebool -P allow_httpd_anon_write=1
semanage fcontext -a -t public_content_rw_t "/mnt/koji(/.*)?"
restorecon -r -v /mnt/koji
exit 0
