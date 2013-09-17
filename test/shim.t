#!/bin/bash

set -e

# Emulate skip_all:
if [[ ! "$(which perl)" =~ ^$PWD/shims/perl$ ]]; then
    echo "1..0 # SKIP plenv is not installed"
    exit 0
fi

PATH=ext/test-simple-bash/lib:$PATH
source test-simple.bash tests 1     # plan == 1

ok [ "$(perl -E 'say $ENV{PLENV_DIR}' test/shim.t)" == "$PWD" ] \
    'Shim knows about -E'
