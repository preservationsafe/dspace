#!/bin/bash
set -x

DEFAULT_CONTAINER="mysql-db3"

CONTAINER=${4:-$DEFAULT_CONTAINER}
REPOSITORY=${3:-db3-mysql}
ACTION=$2
TAG=${1:-latest}
DAEMONIZE=-d

# Delete test container built from docker file
docker stop $CONTAINER
docker rm $CONTAINER

if [ "$ACTION" = "BUILD" ]; then
# Delete test image built from docker file
docker image rm $REPOSITORY:$TAG

# test CREATE image from docker file
docker build --rm=true -t $REPOSITORY:$TAG $REPOSITORY/$TAG

fi

if [ "$ACTION" = "DEBUG" ]; then
    DAEMONIZE=""
    DEBUG="--user root -it --entrypoint /bin/bash"
fi

if [ "$ACTION" = "INSTALL" ]; then

NETWORK="deepfreeze-network"
HOSTLOG=/mnt/s18d1/db3-logs/mysql

# Create isolated network
docker network create --driver bridge $NETWORK

# Create test container from docker file
docker run $DAEMONIZE $DEBUG \
       --restart=always \
       --net=$NETWORK \
       --name $CONTAINER  \
       --tmpfs /tmp \
       -v $HOSTLOG:/var/log \
       dockerepo/$REPOSITORY:$TAG


else

# Create test container from docker file
docker run $DAEMONIZE $DEBUG \
       --name $CONTAINER  \
       -p 3306:3306 \
       --tmpfs /tmp \
       --tmpfs /var/log:uid=27,gid=27,mode=777,noexec,nodev,nosuid \
       $REPOSITORY:$TAG

fi
