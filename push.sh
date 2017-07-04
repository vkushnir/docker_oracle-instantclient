#!/bin/bash
DPATH="$( dirname ${BASH_SOURCE} )"
source $DPATH/docker.conf

echo "Push docker image '$DTAG'"
docker push $DTAG
if [ $# -ge 1 ]; then
    echo "Push docker image '$DTAG-$1'"
    docker push $DTAG-$1
fi
