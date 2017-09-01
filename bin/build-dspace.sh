#!/bin/bash

if [ "$HOME" == "/opt/tomcat/dspace" ]; then
  DSPACE_HOME_DIR="$HOME"
else
  SHELL_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  DSPACE_HOME_DIR="$( cd $SHELL_SCRIPT_DIR/.. && pwd )"
  while [ ! -d "$DSPACE_HOME_DIR/overlay" ]; do
      DSPACE_HOME_DIR="$( cd $DSPACE_HOME_DIR/.. && pwd )"
  done
fi

DSPACE_SRC="$DSPACE_HOME_DIR/src"

# Pickup latest overlays
cd $DSPACE_HOME_DIR && bin/overlay-softlink.sh overlay src

# Default to a dev build
if [ ! -f "$DSPACE_SRC/dspace/config/local.cfg" ]; then
    cp "$DSPACE_SRC/dspace/config/local.cfg-dev" "$DSPACE_SRC/dspace/config/local.cfg"
fi

# Build dspace:
cd $DSPACE_SRC && mvn package

# Install dspace:
cd $DSPACE_SRC/dspace/target/dspace-installer && ant fresh_install
