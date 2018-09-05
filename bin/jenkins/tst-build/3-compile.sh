echo "COMPILING $JOB_BASE_NAME $SRC_TAG"

docker exec "build-dspace6-tst" bash -i -c "cd /opt/tomcat/dspace && bin/solr-recreate-index.sh"

docker exec "build-dspace6-tst" bash -c "/opt/tomcat/bin/shutdown.sh" || echo "shutdown down"

