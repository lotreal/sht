#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

# <-- GETOPT BEGIN
# brew install gnu-getopt
GETOPT=/usr/local/bin/getopt
OPTS=`$GETOPT -o vnh --long verbose,dry-run,help -n 'parse-options' -- "$@"`

if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; exit 1 ; fi

eval set -- "$OPTS"

VERBOSE=false
HELP=false
DRY_RUN=false

while true; do
    case "$1" in
        -v | --verbose ) VERBOSE=true; shift ;;
        -h | --help )    HELP=true; shift ;;
        -n | --dry-run ) DRY_RUN=true; shift ;;
        -- ) shift; break ;;
        * ) break ;;
    esac
done
# GETOPT END -->

SCRIPT_ROOT=$( cd "$( dirname "$(readlink ${BASH_SOURCE})" )" && pwd -P )

WORKDIR=$(pwd)
if [[ $WORKDIR == $HOME* ]]; then
    WORKDIR=~${WORKDIR#$HOME}
fi

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
    echo RUN: $@

    if [[ $DRY_RUN != true ]]; then
        eval $@
    fi
}

echo-and-run() {
    echo RUN: $@ && eval $@
}


SUB=${CMD}/$1

shift

ARG=$@

source $SUB $ARG
