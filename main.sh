#!/usr/bin/env bash
_WD=$( cd "$( dirname "$(readlink ${BASH_SOURCE})" )" && pwd -P )
CMD=${_WD}/cmd

if [ "$#" -lt 1 ]; then
    cat <<EOF
Commands:

  launch		search service in osx launchagents dirs.
  sync-docker-image	sync docker images: DIST_HOSTNAME IMAGES_FILE/IMAGE_NAME
EOF
    exit
fi

SUB=${CMD}/$1

shift

ARG=$@

source $SUB $ARG
