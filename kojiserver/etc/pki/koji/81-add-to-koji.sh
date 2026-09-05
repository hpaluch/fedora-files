#!/bin/bash
set -xeuo pipefail
su - ansible -c "koji add-host fed44-koji.example.com i386 x86_64"
exit 0
