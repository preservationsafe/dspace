SRC_TAG=1.1-$BUILD_ID

echo "BUILDING $JOB_BASE_NAME $SRC_TAG"

git tag $SRC_TAG
git checkout $SRC_TAG

docker start "build-dspace6-dev" || echo "container started"

docker exec "build-dspace6-dev" bash -c -i "/opt/tomcat/dspace/bin/build-dspace.sh reset"

docker exec "build-dspace6-dev" bash -c -i "/opt/tomcat/dspace/bin/build-dspace.sh build dev"

echo "export SRC_TAG=$SRC_TAG" > dspace-install/build-tag.sh
