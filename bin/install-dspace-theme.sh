#!/bin/sh
set -x

DSPACE_DIRS="`ls /opt/tomcat/dspace`"

for THEME in $1; do
    mkdir /opt/tomcat/$THEME
    cd /opt/tomcat/$THEME
    for DIR in $DSPACE_DIRS; do
        ln -s ../dspace/$DIR .
    done
    rm config log
    mkdir log
    cp -a ../dspace/config .
    cd ..
    sed -i "/opt.tomcat.dspace/c\\dspace.dir = /opt/tomcat/$THEME" $THEME/config/local.cfg
    sed -i "s/:8080\/jspui/:8080\/$THEME/g" $THEME/config/local.cfg
    sed -i "/opt.tomcat.dspace/c\\    <param-value>/opt/tomcat/$THEME</param-value>" webapps/$THEME/WEB-INF/web.xml 
done
