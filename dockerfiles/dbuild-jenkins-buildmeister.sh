#!/bin/bash
set -x

DEFAULT_CONTAINER="jenkins-build"

CONTAINER=${4:-$DEFAULT_CONTAINER}
REPOSITORY=${3:-jenkins-buildmeister}
ACTION=$2
TAG=${1:-latest}
DAEMONIZE=-d

# Delete test container built from docker file
docker stop $CONTAINER
docker rm $CONTAINER

if [ "$ACTION" = "BUILD" ]; then
# Delete test image built from docker file
docker image rm $REPOSITORY:$TAG

# Create test image from docker file
docker build --rm=true -t $REPOSITORY:$TAG $REPOSITORY/$TAG

fi

if [ "$ACTION" = "DEBUG" ]; then
    DAEMONIZE=""
    DEBUG="--user root -it --entrypoint /bin/bash"
fi

if [ "$ACTION" = "INSTALL" ]; then

HOSTLOG=/tmp/log
NETWORK="private-network"

docker run $DAEMONIZE $DEBUG \
       --net=$NETWORK \
       -p 8080:8080 \
       --name $CONTAINER \
       $REPOSITORY:$TAG

else

docker run $DAEMONIZE $DEBUG \
       -p 8080:8080 \
       --name $CONTAINER \
       $REPOSITORY:$TAG

fi
