#!/bin/bash
# setup Apache SSL conf to use our certificates
set -xeuo pipefail
f=/etc/httpd/conf.d/kojiweb.conf
# tricky stuff: we want to keep '# uncomment line' in replacement range
sed -i.orig '/uncomment.*SSL/,/^$/s/^# \([^u]\)/\1/' $f
diff -u $f{.orig,} || true
httpd -t
exit 0
