#!/bin/bash

if [ "$HOME" == "/opt/tomcat/dspace" ]; then
  DSPACE_HOME_DIR="$HOME"
else
  SHELL_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  DSPACE_HOME_DIR="$( cd $SHELL_SCRIPT_DIR/../.. && pwd )"
fi

DSPACE_SRC="$DSPACE_HOME_DIR/src"

# Pickup latest overlays
cd $DSPACE_HOME_DIR && campusrepo/bin/overlay-softlink.sh campusrepo src

# Build dspace:
cd $DSPACE_SRC && mvn package

# Install dspace:
cd $DSPACE_SRC/dspace/target/dspace-installer && ant fresh_install
