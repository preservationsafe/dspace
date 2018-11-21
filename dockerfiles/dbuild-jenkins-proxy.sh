#!/bin/bash
set -x

DEFAULT_CONTAINER="build-proxy"

CONTAINER=${4:-$DEFAULT_CONTAINER}
REPOSITORY=${3:-jenkins-proxy}
ACTION=$2
TAG=${1:-1.0}
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
       -p 80:80 \
       -p 443:443 \
       --read-only \
       --tmpfs /tmp/ \
       --tmpfs /var/cache/nginx:mode=755,noexec,nodev,nosuid \
       -v $HOSTLOG:/var/log/nginx \
       -v /etc/nginx:/etc/nginx \
       --name $CONTAINER \
       $REPOSITORY:$TAG

else

docker run $DAEMONIZE $DEBUG \
       -p 80:80 \
       -p 443:443 \
       --read-only \
       --tmpfs /tmp/ \
       --tmpfs /var/cache/nginx:mode=755,noexec,nodev,nosuid \
       --tmpfs /var/log/nginx:uid=105,gid=106,mode=700,noexec,nodev,nosuid \
       --name $CONTAINER \
       $REPOSITORY:$TAG

fi
