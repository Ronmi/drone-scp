#!/bin/bash

function chk {
    if [[ $1 == "" ]]
    then
	echo "missing $2."
	exit 1
    fi
}

chk "$PLUGIN_SRCGLOB" "srcglob"
chk "$PLUGIN_DSTDIR" "dstdir"
chk "$PLUGIN_HOST" "host"
chk "$PLUGIN_USER" "user"
chk "$PLUGIN_PRIVKEY" "privkey"

sshdir=$(mktemp -d)
chmod 700 "$sshdir"
echo "$PLUGIN_PRIVKEY" > "${sshdir}/identity"
chmod 600 "${sshdir}/identity"


if [[ $PLUGIN_CD != "" ]]
then
    cd "$PLUGIN_CD"
fi

set -x

eval "scp -o 'StrictHostKeyChecking no' -r -i '${sshdir}/identity' ${PLUGIN_SRCGLOB} '${PLUGIN_USER}@${PLUGIN_HOST}:${PLUGIN_DSTDIR}'"

if [[ $PLUGIN_POSTEXEC != "" ]]
then
    eval "ssh -o 'StrictHostKeyChecking no' -i '${sshdir}/identity' '${PLUGIN_USER}@${PLUGIN_HOST}' $PLUGIN_POSTEXEC"
fi
