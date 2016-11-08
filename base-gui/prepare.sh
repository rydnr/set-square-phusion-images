#!/bin/bash

echo -n "XSOCK=/tmp/.X11-unix; XAUTH=/tmp/.docker.xauth; xauth nlist :0 | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge - ; ";
echo -n 'docker run -it --rm -v $XSOCK:$XSOCK -v $XAUTH:$XAUTH -e XAUTHORITY=$XAUTH ';
echo "${SQ_REGISTRY}/${SQ_NAMESPACE}/${SQ_IMAGE}:${SQ_TAG}";
