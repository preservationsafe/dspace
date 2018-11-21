#!/bin/sh
CONTAINER=image-db3
#CONTAINER=http-db3
docker cp $CONTAINER:/htaccess.list .
docker cp $CONTAINER:/htaccess.tar.gz .
docker cp $CONTAINER:/mysql.list .
docker cp $CONTAINER:/mysql.tar.gz .
