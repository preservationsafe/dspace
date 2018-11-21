#!/bin/bash
set -x

if [ -f "$HOME/bin/docker-default-container.sh" ]; then
. $HOME/bin/docker-default-container.sh
else
DEFAULT_CONTAINER="http-firstfolio"
fi

CONTAINER=${3:-$DEFAULT_CONTAINER}
REPOSITORY=${2:-firstfolio}
ACTION=$1
DAEMONIZE=-d

# Delete test container built from docker file
docker stop $CONTAINER
docker rm $CONTAINER

if [ "$ACTION" = "BUILD" ]; then
# Delete test image built from docker file
docker image rm $REPOSITORY

# Create test image from docker file
docker build --rm=true -t $REPOSITORY:latest $REPOSITORY/
fi

# Create test container from docker file
docker run -p 7080:6080 -p 7443:6443 $DAEMONIZE \
       --read-only --tmpfs /run --tmpfs /run/lock \
       --tmpfs /tmp --tmpfs /var/log/apache2 \
       --name $CONTAINER \
       $REPOSITORY:latest

#       --name $CONTAINER --entrypoint "/usr/sbin/apachectl" 
#       $REPOSITORY:latest -DFOREGROUND

#       -it --name $CONTAINER $REPOSITORY:latest "/bin/bash"
