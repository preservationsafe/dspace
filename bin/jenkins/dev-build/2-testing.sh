. dspace-install/build-tag.sh

echo "TESTING $JOB_BASE_NAME $SRC_TAG"

docker exec "build-dspace6-dev" bash -c -i "/opt/tomcat/dspace/bin/build-dspace.sh test"

docker exec "build-dspace6-dev" bash -c "cd /opt/tomcat/dspace && bin/fix-permissions.sh"

docker stop "build-dspace6-dev" || echo "container stopped"

git push origin $SRC_TAG
