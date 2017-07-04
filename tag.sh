#!/bin/bash
DPATH="$( dirname ${BASH_SOURCE} )"
source $DPATH/docker.conf

if [ $# -lt 1 ]; then
    echo "Enter new docker image tag"
    exit 1
fi
echo "Tag docker image from '$DTAG' to '$DTAG:$1'"
docker tag $DTAG $DTAG:$1

