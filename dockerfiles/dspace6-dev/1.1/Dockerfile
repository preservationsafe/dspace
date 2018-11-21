#
# DSpace v6.x Dockerfile, using ubuntu 16.04, oracle jdk7
#
# https://vitae/....
#

# Pull base image, ubuntu 16.04 + oracle jdk7.0.80 + tomcat 7.0.x
FROM dockerepo.library.arizona.edu:5000/dspace6-dev:1.0

# Set user/work dir back to root to install packages
USER root
WORKDIR /

# Removed old /opt/tomcat/dspace
RUN rm -fr /opt/tomcat/dspace

# Add new /opt/tomcat/dspace structure
ADD campusrepo /opt/tomcat/dspace

# Add updated local.cfg configuration
ADD local.cfg /opt/tomcat/dspace/dspace/config/local.cfg

# Update tomcat configuration to point to dspace-install
RUN rm -fr /opt/tomcat/conf/Catalina
ADD tomcat/conf/Catalina /opt/tomcat/conf/Catalina

# Change permissions of installed tomcat7 configuration
RUN \
chown -R dspace.dspace /opt/tomcat/conf/Catalina && \
chown -R dspace.dspace /opt/tomcat/dspace

# Set user to run as dspace
USER dspace

# Force shell access into docker container to be /opt/tomcat
WORKDIR $CATALINA_HOME

# Force start of container to also also autostart tomcat7
CMD bin/catalina.sh run
