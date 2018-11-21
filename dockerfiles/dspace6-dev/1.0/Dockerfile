#
# DSpace v6.x Dockerfile, using ubuntu 16.04, oracle jdk7
#
# https://vitae/....
#

# Pull base image, ubuntu 16.04 + oracle jdk7.0.80 + tomcat 7.0.x
FROM tomcat8:latest

# Set user/work dir back to root to install packages
USER root
WORKDIR /

# Make apt-get commands temporarily non-interactive
# Solution from https://github.com/phusion/baseimage-docker/issues/58
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install useful utilities:
RUN \
apt-get update && \
apt-get install -y apt-transport-https emacs-nox vim git curl ant

# Clear out the apt-cache, save some space
RUN \
apt-get clean

# Restore apt-get commands to interactive
RUN echo 'debconf debconf/frontend select Teletype' | debconf-set-selections

# Create dspace uid.gid
RUN \
groupadd dspace --gid 800 && \
useradd dspace --uid 800 --gid 800 --home /opt/tomcat/dspace --shell /bin/bash && \
usermod -a -G tomcat dspace && \
usermod -a -G dspace tomcat

# Overlay customized dspace tomcat build files, first backing up originals
# The overlay includes:
RUN \
mv /opt/tomcat/conf/web.xml /opt/tomcat/conf/web.xml.orig && \
mv /opt/tomcat/conf/server.xml /opt/tomcat/conf/server.xml.orig
COPY tomcat/ /opt/tomcat/

# Install dspace6.0 from tarball pulled from https://github.com/DSpace/DSpace/releases/tag/dspace-6.1
ADD dspace-6.1-src-release.tar.gz /opt/tomcat/dspace

# Rename the long dspace-6.1-src-release to just src:
RUN mv /opt/tomcat/dspace/dspace-6.1-src-release /opt/tomcat/dspace/src

# Overlay custom build, install, and mirage2 settings into build space
RUN cp -f /opt/tomcat/dspace/run/config/* /opt/tomcat/dspace/src/dspace/config

# Install apache maven
ADD apache-maven-3.5.0-bin.tar.gz /opt/tomcat/dspace

# Overlay disabling of dspace-rest requiring SSL
COPY opt.tomcat.dspace.src.dspace-rest.src.main.webapp.WEB-INF.web.xml /opt/tomcat/dspace/src/dspace-rest/src/main/webapp/WEB-INF/web.xml

# Change permissions of installed tomcat7 to dspace.dspace
# move into the /opt/tomcat directory
RUN \
chown -R dspace.dspace /var/log/tomcat && \
chown -R dspace.dspace /opt/tomcat && \
mv /opt/tomcat/dspace/run/log /var/log/dspace && \
ln -s /var/log/dspace /opt/tomcat/dspace/run/log

# Relocate apache maven
RUN \
mv /opt/tomcat/dspace/apache-maven-3.5.0 /usr/local/maven-3.5.0 && \
echo  >> /opt/tomcat/dspace/.bashrc && \
echo 'export JAVA_HOME=/usr/lib/jvm/java-8-oracle' >> /opt/tomcat/dspace/.bashrc && \
echo 'export M2_HOME=/usr/local/maven-3.5.0' >> /opt/tomcat/dspace/.bashrc && \
cd /opt/tomcat/dspace && cp -a campusrepo/bin bin

# Remove unneeded default tomcat webapps, improves security
RUN \
rm -fr /opt/tomcat/webapps/docs && \
rm -fr /opt/tomcat/webapps/examples && \
rm -fr /opt/tomcat/webapps/ROOT

# Force access to docker container as user 'dspace'
USER dspace

# Environment variables needed for catalina to run.
ENV \
CATALINA_OPTS="$JAVA_OPTS \
-XX:PermSize=256m \
-XX:MaxPermSize=512m \
-agentlib:jdwp=transport=dt_socket,address=8000,server=y,suspend=n"
#-Xms8192m \
#-Xmx16384m \

# Force shell access into docker container to be /opt/tomcat
WORKDIR $CATALINA_HOME

# Force start of container to also also autostart tomcat7
CMD bin/catalina.sh run
