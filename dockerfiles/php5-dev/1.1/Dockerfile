#
# php5 dev environment, mirroring the environment on vitae
#

FROM php5-dev:1.0

MAINTAINER Geoff Brimhall <glbrimhall@email.arizona.edu>

# Set user/work dir back to root to install packages
USER root
WORKDIR /

# Overlay vitae's /usr/local ontop of the docker image
ADD vitae.usr.bin.local.tar.gz /usr

# Set default login to buildmeister
USER buildmeister
WORKDIR /home/buildmeister
