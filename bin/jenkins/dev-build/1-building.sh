SRC_TAG=1.0-$BUILD_ID

echo "BUILDING $JOB_BASE_NAME"

git tag $SRC_TAG
git checkout $SRC_TAG

bin/build-dspace.sh clean

docker start "build-dspace6-dev" || echo "container started"

docker exec "build-dspace6-dev" bash -i "/opt/tomcat/dspace/bin/build-dspace.sh"

echo "export SRC_TAG=$SRC_TAG" > run/build-tag.sh
