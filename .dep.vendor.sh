# Auto generate by dep.sh


mvn:install:dir() {
    find ${1:-vendor} -name "*.pom" ${2:-} -print0 |
        while IFS= read -r -d '' POM; do
            mvn:install-pom $POM
            done
}

mvn:install-pom() {
    local POM=$1
    local JAR

    JAR=${POM%.pom}.jar
    if [ -s $JAR ]; then
        mvn:install-file $POM $JAR jar
        return
    fi

    JAR=${POM%.pom}-tests.jar
    if [ -s $JAR ]; then
        mvn:install-file $POM $JAR test-jar
        return
    fi

    mvn:install-file $POM $POM pom
}

mvn:install-file() {
    logger:run mvn install:install-file -DpomFile=$1 -Dfile=$2 -Dpackaging=$3 ${MVN_OPTS}
}

assert:notEmpty() {
    local var=$(eval echo \$$1)
    if [ -z "$var" ]; then
        echo "FAIL: $1 does not defined, or is empty"
        exit 127
    else
        echo "ECHO: $1=$var"
    fi
}

assert:defined() {
    echo
}

logger:run() {
    if [[ ${DRYRUN:-false} != true ]]; then
        eval ${COMMAND_LINE}
    fi

    echo "[INFO] RUN: $*" && eval "$*"
    return_value=$?
    if [ "$return_value" != "0" ]; then
        echo "[ERROR] \"$*\" STOPPED WITH EXIT CODE $return_value."
        exit $return_value
    fi
}

import:sh() {
    local file=$1
    if [ -s "$file" ]; then
        source $file
    else
        echo "FAIL: file $file does not exist, or is empty"
        exit 127
    fi
}

fn:run() {
    for cmd in $*; do
        echo [MAKE] call $cmd...
        $cmd
    done
}

ACTIVE_PROFILE=${ACTIVE_PROFILE:-${DEFAULT_PROFILE:-""}}

if [ -n "${ACTIVE_PROFILE_FILE:-}" ]; then
    if [[ ! -f ${ACTIVE_PROFILE_FILE} && ${GLOBAL_INTERACTIVE} = 1 ]]; then
        echo "valid value: (1-5,default)"
        echo "default value: dafult"
        read -p "> "
        echo ${REPLY:-${ACTIVE_PROFILE}} > ${ACTIVE_PROFILE_FILE}
    fi

    [[ -f ${ACTIVE_PROFILE_FILE} && -s ${ACTIVE_PROFILE_FILE} ]] && PROFILE=$(cat ${ACTIVE_PROFILE_FILE})
fi

PROFILE=${PROFILE:-${ACTIVE_PROFILE}}

echo "[INFO] Active Profile = $PROFILE"
fn:mock() {
    local NAME=$1
    local BODY=$(cat <<-END
$NAME() {
    echo $NAME
}
END
         )
    eval "$BODY"
}
