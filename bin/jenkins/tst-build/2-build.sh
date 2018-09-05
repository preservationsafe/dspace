TST_TAG=1.1-$BUILD_ID

echo "BUILDING $JOB_BASE_NAME $SRC_TAG"

#cp bin/Dockerfile-env Dockerfile-tst

#sed -i "s/__DSPACE_BUILD_TAG__/$SRC_TAG/g" Dockerfile-tst
#sed -i "s/__DSPACE_STAGE_ENV__/tst/g" Dockerfile-tst

#docker build --rm=true -t dspace6-tmptst:$SRC_TAG -f Dockerfile-tst .

echo "export SRC_TAG=$SRC_TAG" >  build-tag.sh
echo "export TST_TAG=$TST_TAG" >> build-tag.sh

docker rm -f build-dspace6-tst || echo "build-dspace6-tst already deleted"

export JAVA_OPTS="\
-Xms4096m \
-Xmx8192m \
-XX:PermSize=256m \
-XX:MaxPermSize=512m"

docker run -d \
  --net=$JOB_BASE_NAME \
  -e JAVA_OPTS="$JAVA_OPTS" \
  -v /mnt/dspace-assetstore-tst:/opt/tomcat/assetstore \
  --name build-dspace6-tst \
  dockerepo.library.arizona.edu:5000/dspace6-dev:$SRC_TAG

docker cp build-tag.sh build-dspace6-tst:/opt/tomcat/dspace/dspace-install/build-tag.sh

docker exec "build-dspace6-tst" bash -c -i "/opt/tomcat/dspace/bin/build-dspace.sh env tst"

docker exec "build-dspace6-tst" bash -c -i "rm -fr /opt/tomcat/dspace/dspace"

docker exec "build-dspace6-tst" bash -c -i "rm -fr /opt/tomcat/dspace/.m2"

#docker exec "build-dspace6-tst" bash -i -c "cd /opt/tomcat/dspace && bin/overlay-config.pl tst dspace-install/config"

