#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

#SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
source $SCRIPT_DIR/function/test_fun.sh

test_print
test_cat
#ping_hosts
