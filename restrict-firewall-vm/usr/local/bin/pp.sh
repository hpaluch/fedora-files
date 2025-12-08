#!/bin/bash
# Temporarily enable outgoing https(s) for provided command.
set -euo pipefail

sd=' '
[ `id -u` -eq 0 ] || sd='sudo '

function enable_out_conn
{
	local cmd="${sd}firewall-cmd --policy=out --add-service=https --add-service=http"
	echo -n "INFO: Enabling output connections: $cmd"
	$cmd
}

function disable_out_conn
{
	local cmd="${sd}firewall-cmd --policy=out --remove-service=https --remove-service=http"
	echo -n "INFO: Disabling output connections: $cmd"
	$cmd
}

function exit_handler
{
	disable_out_conn
	echo "INFO: Policy 'out' on exit:"
	${sd}firewall-cmd --info-policy=out
}

[ $# -gt 0 ] || {
	echo "ERROR: Usage: $0 command_to_run args..." >&2
	exit 1
}

enable_out_conn
trap exit_handler EXIT
echo "INFO: Running '$@' ..."
"$@"
echo "INFO: Done with exit code: $?"
exit 0
