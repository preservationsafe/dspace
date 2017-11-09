#!/bin/bash

. "$( dirname "${BASH_SOURCE[0]}" )/get-dspace-home-dir.sh"

DSPACE_SRC="$DSPACE_HOME_DIR/dspace"
DSPACE_RUN="$DSPACE_HOME_DIR/dspace-install"

# Default to a dev build
if [ ! -f "$DSPACE_SRC/dspace/config/local.cfg" ]; then
    cp "$DSPACE_SRC/dspace/config/local.cfg-dev" "$DSPACE_SRC/dspace/config/local.cfg"
fi

# Build dspace:
cd $DSPACE_SRC && mvn clean package

# Install dspace:
cd $DSPACE_SRC/dspace/target/dspace-installer && ant -Dconfig="$DSPACE_RUN/config/dspace.cfg" update
