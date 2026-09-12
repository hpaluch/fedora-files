#!/bin/bash
set -uo pipefail
cd $(dirname $0)
d=`pwd`

cd /
for o in `find etc -name '*.orig'`; do
	[ "$o" != "etc/pki/koji/ssl.cnf.orig" ] || continue
	[ "$o" != "etc/httpd/conf.d/ssl.conf.orig" ] || continue
	f="${o%%.orig}"
	out="$d/$( basename $f).patch"
	echo "$f"
	diff -u $o $f > $out
done
exit 0

