#!/bin/sh

export CATALINA_OPTS="$JAVA_OPTS \
-XX:PermSize=256m \
-XX:MaxPermSize=512m \
-agentlib:jdwp=transport=dt_socket,address=8000,server=y,suspend=n"

/opt/tomcat/bin/startup.sh
