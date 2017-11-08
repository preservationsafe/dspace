#!/bin/bash

. "$( dirname "${BASH_SOURCE[0]}" )/get-dspace-home-dir.sh"

DSPACE_SRC="$DSPACE_HOME_DIR/src"
DSPACE_RUN="$DSPACE_HOME_DIR/run"

# Pickup latest overlays
cd $DSPACE_HOME_DIR && bin/overlay-softlink.sh overlay src

# Default to a dev build
if [ ! -f "$DSPACE_SRC/dspace/config/local.cfg" ]; then
    cp "$DSPACE_SRC/dspace/config/local.cfg-dev" "$DSPACE_SRC/dspace/config/local.cfg"
fi

# Build dspace:
cd $DSPACE_SRC && mvn clean package

# Install dspace:
cd $DSPACE_SRC/dspace/target/dspace-installer && ant -Dconfig="$DSPACE_RUN/config/dspace.cfg" update
