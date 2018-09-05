docker pull dockerepo.library.arizona.edu:5000/dspace6-dev:1.1
docker network create --driver bridge $JOB_BASE_NAME || echo "network exists"
#export JOB_NETWORK=host
export JOB_NETWORK=$JOB_BASE_NAME

#  -p 4444:4444 \
docker run -d \
  --restart=always \
  --net=$JOB_NETWORK \
  --name build-dspace6-selenium \
  selenium/standalone-firefox:2.53.0 || echo "docker container exists"

#  -p 8080:8080 \
docker run -d \
  --net=$JOB_NETWORK \
  --link build-dspace6-selenium:selenium \
  -v /home/buildmeister/jenkins/workspace/$JOB_BASE_NAME:/opt/tomcat/dspace \
  -v /mnt/dspace-assetstore-dev:/opt/tomcat/assetstore \
  --hostname build-dspace6-dev \
  --name build-dspace6-dev \
  dockerepo.library.arizona.edu:5000/dspace6-dev:1.1 || echo "docker container exists"
