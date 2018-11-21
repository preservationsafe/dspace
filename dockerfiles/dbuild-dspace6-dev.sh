#!/bin/bash
set -x

#if [ -f "$HOME/bin/docker-default-container.sh" ]; then
#. $HOME/bin/docker-default-container.sh
#else
DEFAULT_CONTAINER="my-dspace6-dev"
#fi

CONTAINER=${4:-$DEFAULT_CONTAINER}
REPOSITORY=${3:-dspace6-dev}
ACTION=${2:-RUN}
TAG=${1:-1.0}
DAEMONIZE=-d
NETWORK=host

# Delete test container built from docker file
docker stop $CONTAINER
docker rm $CONTAINER

if [ "$ACTION" = "BUILD" ]; then
# Delete test image built from docker file
docker image rm $REPOSITORY

# Create test image from docker file
docker build --rm=true -t $REPOSITORY:$TAG $REPOSITORY/$TAG

ACTION="DEBUG"
fi

if [ "$ACTION" = "DEBUG" ]; then

docker run \
       --net=$NETWORK \
       -p 8000:8000 \
       -p 8080:8080 \
       -p 8443:8443 \
       -it --entrypoint /bin/bash \
       --user root \
       --name $CONTAINER \
       $REPOSITORY:$TAG

else

docker run $DAEMONIZE \
       --net=$NETWORK \
       -p 8000:8000 \
       -p 8080:8080 \
       -p 8443:8443 \
       --name $CONTAINER \
       $REPOSITORY:$TAG

fi
