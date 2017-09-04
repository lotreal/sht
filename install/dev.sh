#!/usr/bin/env bash
CWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

ROOT_DIR=$( cd $CWD && cd .. && pwd)
SRC_DIR=${ROOT_DIR}/src
INSTALL_DIR=/usr/local/bin

while read src; do
    echo ln -sf ${SRC_DIR}/$src ${INSTALL_DIR}/$src
    ln -sf ${SRC_DIR}/$src ${INSTALL_DIR}/$src
done << EOF
$(ls $SRC_DIR)
EOF
