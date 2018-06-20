#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

SCRIPT_ROOT=$( cd "$( dirname "$(readlink ${BASH_SOURCE})" )" && pwd -P )
WORKDIR=$(pwd)
CMD=${SCRIPT_ROOT}/cmd

if [ "$#" -lt 1 ]; then
    cat <<EOF
iw helm new drone

Commands:

  launch		search service in osx launchagents dirs.
  sync-docker-image	sync docker images: DIST_HOSTNAME IMAGES_FILE/IMAGE_NAME
EOF
    exit
fi

run() {
    echo RUN: $@ && eval $@;
}


SUB=${CMD}/$1

shift

ARG=$@

echo source $SUB $ARG
source $SUB $ARG
