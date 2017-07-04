#!/bin/bash
DPATH="$( dirname ${BASH_SOURCE} )"
source $DPATH/docker.conf

echo "Build docker image '$DTAG'"
docker build $DPATH --tag $DTAG
docker image ls $DTAG
if [ $# -ge 1 ]; then
    echo "Tag docker image from '$DTAG' to '$DTAG-$1'"
    docker tag $DTAG $DTAG-$1
fi
