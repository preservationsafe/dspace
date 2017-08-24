#!/bin/sh

SHELL_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DSPACE_HOME_DIR="$( cd $SHELL_SCRIPT_DIR/../.. && pwd )"
DSPACE_SRC="$DSPACE_HOME_DIR/src"

# Pickup latest overlays
cd $DSPACE_HOME_DIR; campusrepo/bin/overlay-softlinks.sh campusrepo src; cd -

# Build dspace:
cd $DSPACE_SRC; mvn package; cd -

# Install dspace:
cd $DSPACE_SRC/dspace/target/dspace-installer; ant fresh_install; cd -
