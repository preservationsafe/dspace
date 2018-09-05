echo "DEPLOYING $JOB_BASE_NAME $SRC_TAG"

ssh buildmeister@repository-tst.library.arizona.edu "docker pull dockerepo.library.arizona.edu:5000/dspace6-tst:$SRC_TAG"

# For cleanup, get the current running container's image
export PREVIOUS_IMAGE=`ssh buildmeister@repository-tst.library.arizona.edu "docker ps -a" | grep repository-dspace | perl -ne '/(dockerepo\S+)/ && print "$1"'`

echo "export PREVIOUS_IMAGE=$PREVIOUS_IMAGE" >> dspace-install/cleanup.sh

ssh buildmeister@repository-tst.library.arizona.edu "docker rm -f repository-dspace"

export CATALINA_OPTS="\
-Xms8192m \
-Xmx16384m \
-XX:PermSize=256m \
-XX:MaxPermSize=512m"

ssh buildmeister@repository-tst.library.arizona.edu "docker run -d \
-e CATALINA_OPTS=\"$CATALINA_OPTS\" \
-v /mnt/dspace-assetstore-tst:/opt/tomcat/assetstore \
-v /var/log/dspace:/var/log \
--net=repository-tst-network \
--restart=unless-stopped \
--name repository-dspace \
dockerepo.library.arizona.edu:5000/dspace6-tst:$SRC_TAG"

sleep 5

#ssh buildmeister@repository-tst.library.arizona.edu "docker exec repository-dspace bash -l /opt/tomcat/dspace/bin/solr-recreate-index.sh"

#ssh buildmeister@repository-tst.library.arizona.edu "docker exec repository-dspace /opt/tomcat/bin/shutdown.sh"

#ssh buildmeister@repository-tst.library.arizona.edu "docker start repository-dspace"

echo "CLEANING $JOB_BASE_NAME $SRC_TAG $PREVIOUS_IMAGE"

ssh buildmeister@repository-tst.library.arizona.edu "docker image rm $PREVIOUS_IMAGE" || echo "Already cleaned"

sleep 20

