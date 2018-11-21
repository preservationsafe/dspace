#
# jenkins-docker
#
# VERSION   0.0.1

FROM jenkins/jenkins:lts

MAINTAINER Geoff Brimhall <glbrimhall@email.arizona.edu>

# Set user/work dir back to root to install packages
USER root
WORKDIR /

# Make apt-get commands temporarily non-interactive
# Solution from https://github.com/phusion/baseimage-docker/issues/58
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install docker executable requires missing libltdl7
RUN apt-get update

# volume linked /usr/bin/docker executable requires missing libltdl7
RUN apt-get install -y apt-utils libltdl7:amd64 ssh-askpass

# Restore apt-get commands to interactive
RUN echo 'debconf debconf/frontend select Teletype' | debconf-set-selections

# The jenkins user needs to belong to the docker group so it can access /var/run/docker.sock,
# per documentation at
# http://container-solutions.com/running-docker-in-jenkins-in-docker/ and
# https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/
RUN \
groupadd docker --gid 999 && \
usermod -a -G docker jenkins

# Create dspace uid.gid
RUN \
groupadd dspace --gid 800 && \
useradd dspace --uid 800 --gid 800 --home /home/dspace --shell /bin/bash && \
usermod -a -G dspace jenkins

# Rename unix user jenkins to buildmeister
RUN \
cp /etc/passwd /etc/passwd.pre-buildmeister && \
cp /etc/group /etc/group.pre-buildmeister && \
groupmod -n buildmeister jenkins && \
usermod -l buildmeister jenkins

# Build application specific settings: links dspace home directory
#RUN \
#mkdir -p /opt/tomcat &&
#chown -R dspace.dspace /opt/tomcat &&
#ln -s /var/jenkins_home/workspace/dspace-dev-build /opt/tomcat/dspace

# Reset the default user back to buildmeister
USER buildmeister

# We are not overriding the ENTRYPOINT defined in the parent
