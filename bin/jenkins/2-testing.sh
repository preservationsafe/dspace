echo "TESTING $JOB_BASE_NAME"

#docker exec "build-dspace6-dev" bash -i -c "cd /opt/tomcat/dspace/src && mvn test -Dmaven.test.skip=false -DskipITs=false -Dtest='*,!PoiWordFilterTest' -DfailIfNoTests=false"

docker exec "build-dspace6-dev" bash -i -c "cd /opt/tomcat/dspace && bin/fix-permissions.sh"

docker exec "build-dspace6-dev" bash -i -c "/opt/tomcat/bin/shutdown.sh" || echo "shutdown down"

