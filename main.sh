#!/usr/bin/env bash

# https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
set -euo pipefail

SSD="$( cd "$( dirname "$(readlink ${BASH_SOURCE[0]})" )" >/dev/null 2>&1 && pwd )"

source $SSD/dep.sh
source $VENDOR/opts.vn.sh

if [ "$#" -lt 1 ]; then
    cat $SSD/Usage.md
    exit
fi

sub_command=${SSD}/cmd/$1
shift

source ${sub_command} "$@"
