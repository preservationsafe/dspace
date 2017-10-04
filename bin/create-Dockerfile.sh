#!/bin/sh

cp /opt/tomcat/dspace/bin/Dockerfile-env /opt/tomcat/dspace/Dockerfile-$2
sed -i "s/__DSPACE_BUILD_TAG__/$1/g" /opt/tomcat/dspace/Dockerfile-$2
sed -i "s/__DSPACE_STAGE_ENV__/$2/g" /opt/tomcat/dspace/Dockerfile-$2
