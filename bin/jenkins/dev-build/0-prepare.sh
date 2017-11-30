docker pull dockerepo.library.arizona.edu:5000/dspace6-dev:1.0
docker network create --driver bridge $JOB_BASE_NAME || echo "network exists"
docker run -d \
--net=$JOB_BASE_NAME \
-v $JENKINS_HOME/workspace/$JOB_BASE_NAME:/opt/tomcat/dspace \
-v /mnt/dspace-assetstore-dev:/opt/tomcat/assetstore \
--name build-dspace6-dev \
dockerepo.library.arizona.edu:5000/dspace6-dev:1.0 || echo "docker container exists"

