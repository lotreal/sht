#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

# <-- GETOPTS BEGIN
VERBOSE=false
DRY_RUN=false

while getopts ":vn" opt
do
    case $opt in
        v)
            VERBOSE=true
            ;;
        n)
            DRY_RUN=true
            ;;
        ?)
        echo "error"
        exit 1
    esac
done
shift $(( $OPTIND-1 ))
# GETOPTS END -->

# <-- GETOPT BEGIN
# brew install gnu-getopt
# GETOPT=/usr/local/bin/getopt
# OPTS=`$GETOPT -o vnh --long verbose,dry-run,help -n 'parse-options' -- "$@"`

# if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; exit 1 ; fi

# eval set -- "$OPTS"

# VERBOSE=false
# HELP=false
# DRY_RUN=false

# while true; do
#     case "$1" in
#         -v | --verbose ) VERBOSE=true; shift ;;
#         -h | --help )    HELP=true; shift ;;
#         -n | --dry-run ) DRY_RUN=true; shift ;;
#         -- ) shift; break ;;
#         * ) break ;;
#     esac
# done
# GETOPT END -->

# echo $VERBOSE
# echo "$@"
# exit

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
  docker-proxy-pull    pull image from proxy registry, retag it to origin image name
  docker-proxy-push    pull image from origin registry, retag it, and push to proxy registry

  sync-docker-image	sync docker images: DIST_HOSTNAME IMAGES_FILE/IMAGE_NAME

Examples:

$ PROXY_HUB=hub.huwo.io/vendor xy docker-proxy-push gcr.io/google-containers/addon-resizer-amd64:2.1
RUN: docker pull gcr.io/google-containers/addon-resizer-amd64:2.1
2.1: Pulling from google-containers/addon-resizer-amd64
d83a783b3049: Pull complete
ce87eac9db38: Pull complete
Digest: sha256:d00afd42fc267fa3275a541083cfe67d160f966c788174b44597434760e1e1eb
Status: Downloaded newer image for gcr.io/google-containers/addon-resizer-amd64:2.1
RUN: docker tag gcr.io/google-containers/addon-resizer-amd64:2.1 hub.huwo.io/vendor/gcr.io.google-containers.addon-resizer-amd64:2.1
RUN: docker push hub.huwo.io/vendor/gcr.io.google-containers.addon-resizer-amd64:2.1
The push refers to repository [hub.huwo.io/vendor/gcr.io.google-containers.addon-resizer-amd64]
2d040ace018f: Pushed
08c2295a7fa5: Pushed
2.1: digest: sha256:0e6a091ec51434f8733da7e1223f92935da8e70ba37f4030029e9d0767aeeb50 size: 738
[INFO] gcr.io/google-containers/addon-resizer-amd64:2.1 => hub.huwo.io/vendor/gcr.io.google-containers.addon-resizer-amd64:2.1.

$ PROXY_HUB=hub.huwo.io/vendor xy docker-proxy-pull gcr.io/google-containers/addon-resizer-amd64:2.1
RUN: docker push hub.huwo.io/vendor/gcr.io.google-containers.addon-resizer-amd64:2.1
The push refers to repository [hub.huwo.io/vendor/gcr.io.google-containers.addon-resizer-amd64]
2d040ace018f: Layer already exists
08c2295a7fa5: Layer already exists
2.1: digest: sha256:0e6a091ec51434f8733da7e1223f92935da8e70ba37f4030029e9d0767aeeb50 size: 738
RUN: docker tag hub.huwo.io/vendor/gcr.io.google-containers.addon-resizer-amd64:2.1 gcr.io/google-containers/addon-resizer-amd64:2.1
[INFO] gcr.io/google-containers/addon-resizer-amd64:2.1 <= hub.huwo.io/vendor/gcr.io.google-containers.addon-resizer-amd64:2.1.

EOF
    exit
fi

run() {
    COMMAND_LINE="$@"
    echo RUN: ${COMMAND_LINE}

    if [[ $DRY_RUN != true ]]; then
        eval ${COMMAND_LINE}
    fi
}

echo-and-run() {
    echo RUN: $@ && eval $@
}


SUB=${CMD}/$1

shift

source $SUB "$@"
