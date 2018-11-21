#!/bin/bash
set -x

DEFAULT_CONTAINER="build-php5-dev"

CONTAINER=${4:-$DEFAULT_CONTAINER}
REPOSITORY=${3:-php5-dev}
ACTION=${2:-DEBUG}
TAG=${1:-1.0}
DAEMONIZE=-d

# Delete test container built from docker file
docker stop $CONTAINER
docker rm $CONTAINER

if [ "$ACTION" = "BUILD" ]; then
# Delete test image built from docker file
docker image rm $REPOSITORY:$TAG

# Create test image from docker file
docker build -t $REPOSITORY:$TAG $REPOSITORY/$TAG/

ACTION=DEBUG
fi

#DAEMONIZE=""
DEBUG="-it --entrypoint /bin/bash"

if [ "$ACTION" = "DEBUG" ]; then
    DEBUG="--user root $DEBUG"
fi

if [ "$ACTION" = "INSTALL" ]; then

NETWORK="redux-dev-build"

docker run $DAEMONIZE $DEBUG \
       --net=$NETWORK \
       --name $CONTAINER \
       dockerepo/$REPOSITORY:$TAG

else

docker run $DAEMONIZE $DEBUG \
       --net=host \
       --name $CONTAINER \
       $REPOSITORY:$TAG

fi
