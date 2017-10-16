#!/bin/sh
echo "DEPLOYING $JOB_BASE_NAME $SRC_TAG"

ssh buildmeister@repository-tst.library.arizona.edu "docker pull dockerepo.library.arizona.edu:5000/dspace6-tst:$SRC_TAG"

# For cleanup, get the current running container's image
export PREVIOUS_IMAGE=`ssh buildmeister@repository-tst.library.arizona.edu "docker ps -a" | grep dspace6-tst | perl -ne '/(dockerepo\S+)/ && print "$1"'`

echo "export PREVIOUS_IMAGE=$PREVIOUS_IMAGE" >> run/cleanup.sh

ssh buildmeister@repository-tst.library.arizona.edu "docker rm -f dspace6-tst"

export CATALINA_OPTS="$JAVA_OPTS \
-Xms8192m \
-Xmx16384m \
-XX:PermSize=256m \
-XX:MaxPermSize=512m"

ssh buildmeister@repository-tst.library.arizona.edu "docker run -d \
-e CATALINA_OPTS=\"$CATALINA_OPTS\" \
-v /dspace-assetstore:/opt/tomcat/assetstore \
-v /var/log/dspace:/var/log \
--net=host \
--restart=unless-stopped \
--name dspace6-tst \
dockerepo.library.arizona.edu:5000/dspace6-tst:$SRC_TAG"

sleep 5

ssh buildmeister@repository-tst.library.arizona.edu "docker exec dspace6-tst bash -l /opt/tomcat/dspace/bin/solr-recreate-index.sh"

ssh buildmeister@repository-tst.library.arizona.edu "docker exec dspace6-tst /opt/tomcat/bin/shutdown.sh"

ssh buildmeister@repository-tst.library.arizona.edu "docker start dspace6-tst"

echo "CLEANING $JOB_BASE_NAME $SRC_TAG $PREVIOUS_IMAGE"

ssh buildmeister@repository-tst.library.arizona.edu "docker image rm $PREVIOUS_IMAGE" || echo "Already cleaned"

sleep 20
