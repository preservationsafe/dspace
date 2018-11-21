#!/bin/bash
set -x

DEFAULT_CONTAINER="proxy-db3"

CONTAINER=${4:-$DEFAULT_CONTAINER}
REPOSITORY=${3:-deepfreeze-proxy}
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

HOSTLOG=/mnt/s18d1/db3-logs/nginx
NETWORK="deepfreeze-network"

docker run $DAEMONIZE $DEBUG \
       --restart=always \
       --net=$NETWORK \
       -p 80:80 \
       -p 443:443 \
       --read-only \
       --tmpfs /tmp/ \
       --tmpfs /var/cache/nginx:mode=755,noexec,nodev,nosuid \
       -v /etc/nginx:/etc/nginx \
       -v $HOSTLOG:/var/log/nginx \
       --link http-db3:http-host \
       --name $CONTAINER \
       dockerepo/$REPOSITORY:$TAG

else

docker run $DAEMONIZE $DEBUG \
       -p 80:80 \
       -p 443:443 \
       --read-only \
       --tmpfs /tmp/ \
       --tmpfs /var/cache/nginx:mode=755,noexec,nodev,nosuid \
       --tmpfs /var/log/nginx:uid=105,gid=106,mode=700,noexec,nodev,nosuid \
       --link http-db3:http-host \
       --name $CONTAINER \
       $REPOSITORY:$TAG

fi
