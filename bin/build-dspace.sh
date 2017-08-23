#!/bin/sh

DSPACE_SRC=/opt/tomcat/dspace/src

# Build dspace:
cd $DSPACE_SRC && mvn package

# Install dspace:
cd $DSPACE_SRC/dspace/target/dspace-installer && ant fresh_install
