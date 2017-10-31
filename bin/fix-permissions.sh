#!/bin/bash

. "$( dirname "${BASH_SOURCE[0]}" )/get-dspace-home-dir.sh"

function exec_cmd() {
   local CMD="$1"
   echo "EXEC: $CMD"
   local OUT=$(eval $CMD)
}

exec_cmd "chgrp -R dspace $DSPACE_HOME_DIR 2>/dev/null"
exec_cmd "find $DSPACE_HOME_DIR -type f -print0 | xargs -0 chmod 664 2>/dev/null"
exec_cmd "find $DSPACE_HOME_DIR -type d -print0 | xargs -0 chmod 2775 2>/dev/null"
exec_cmd "find $DSPACE_HOME_DIR/bin -type f -print0 | xargs -0 chmod 775 2>/dev/null"
exec_cmd "find $DSPACE_HOME_DIR/src/dspace/bin -type f -print0 | xargs -0 chmod 775 2>/dev/null"

if [ -d "$DSPACE_HOME_DIR/run/bin" ]; then
   exec_cmd "find $DSPACE_HOME_DIR/run/bin -type f -print0 | xargs -0 chmod 775 2>/dev/null"
fi
