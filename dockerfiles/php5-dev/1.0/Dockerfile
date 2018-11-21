#
# php5 dev environment, mirroring the environment on vitae
#

FROM technopreneural/docker-ubuntu-14.04-php5

MAINTAINER Geoff Brimhall <glbrimhall@email.arizona.edu>

# Set user/work dir back to root to install packages
USER root
WORKDIR /

# Update apt sources to fastest local mirror
RUN mv /etc/apt/sources.list /etc/apt/sources.list-archive.ubuntu.com
COPY sources.list-mirrors.os6.org /etc/apt/sources.list

# Make apt-get commands temporarily non-interactive
# Solution from https://github.com/phusion/baseimage-docker/issues/58
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install docker executable requires missing libltdl7
RUN apt-get update

# Additional php5 packages on vitae that are not in parent docker
# calculated via doing a dpkg -l | grep php5 on vitae
RUN apt-get install -y php5-json php5-readline php5-xdebug php-pear pkg-php-tools

# Restore apt-get commands to interactive
RUN echo 'debconf debconf/frontend select Teletype' | debconf-set-selections

# Add php dependencies installed through PEAR
RUN pear install Archive_Tar Console_Getopt PEAR Structures_Graph VersionControl_Git XML_Util

# Add a default build user
RUN useradd -m -c "Build Meister" buildmeister

# The buildmeister user needs to belong to the docker group so it can access /var/run/docker.sock,
# per documentation at
# http://container-solutions.com/running-docker-in-jenkins-in-docker/ and
# https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/
RUN \
groupadd docker --gid 999 && \
usermod -a -G docker buildmeister

# Set default login to buildmeister
USER buildmeister
WORKDIR /home/buildmeister

# Set bash as the default entry point, disabling apache autostart
CMD /bin/bash
