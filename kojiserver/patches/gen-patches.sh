#!/bin/bash
set -xuo pipefail
cd $(dirname $0)
d=`pwd`

cd /
for o in `find etc -name '*.orig'`; do
	f="${o%%.orig}"
	out="$d/$( basename $f).patch"
	diff -u $o $f > $out
done
exit 0

