#!/bin/bash
DPATH="$( dirname ${BASH_SOURCE} )"
source $DPATH/docker.conf

echo "Run docker image '$DTAG'"
if [ $# -ge 1 ]; then
    ep=$1
    shift 1
    docker run -it --rm $DOPT --entrypoint=$ep $DTAG $@
else
    docker run -it --rm $DOPT $DTAG
fi
