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

echo "SHELL_SCRIPT_DIR = $SHELL_SCRIPT_DIR"
echo "DSPACE_HOME_DIR  = $DSPACE_HOME_DIR"

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
