#!/bin/bash
set -x

DEFAULT_CONTAINER="http-db3"

CONTAINER=${4:-$DEFAULT_CONTAINER}
REPOSITORY=${3:-db3-http}
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
docker build --rm=true -t $REPOSITORY:$TAG $REPOSITORY/$TAG/

ACTION=DEBUG
fi

if [ "$ACTION" = "DEBUG" ]; then
    DAEMONIZE=""
    DEBUG="--user root -it --entrypoint /bin/bash"
fi

if [ "$ACTION" = "INSTALL" ]; then

NETWORK="deepfreeze-network"
HOSTLOG=/mnt/s18d1/db3-logs/http
HOSTREPO=/mnt/s18d1

# Create test container from docker file
# 6080/6443 is for digitalcommons
# 6081/6444 is for devcommons
# 6082 is for jaei
docker run $DAEMONIZE $DEBUG \
      --restart=always \
       --net=$NETWORK \
       --read-only \
       --tmpfs /run --tmpfs /run/lock \
       --tmpfs /tmp/phpsess --tmpfs /var/run \
       -v $HOSTLOG/log:/var/log/httpd \
       -v $HOSTLOG/uair:/data1/uairlogs \
       -v $HOSTREPO:/mnt/s18d1 \
       --link mysql-db3:db-host \
       --name $CONTAINER \
       dockerepo/$REPOSITORY:$TAG

else

docker run $DAEMONIZE $DEBUG \
       -p 6080:6080 -p 6443:6443 \
       -p 6081:6081 -p 6444:6444 \
       -p 6082:6082 \
       --read-only \
       --tmpfs /run --tmpfs /run/lock \
       --tmpfs /tmp/phpsess --tmpfs /var/run \
       --tmpfs /var/log/httpd:uid=48,gid=48,mode=700,noexec,nodev,nosuid \
       --tmpfs /data1/uairlogs:uid=48,gid=48,mode=700,noexec,nodev,nosuid \
       --tmpfs /mnt/s18d1:uid=48,gid=48,mode=775,noexec,nodev,nosuid \
       --link mysql-db3:db-host \
       --name $CONTAINER \
       $REPOSITORY:$TAG

fi
