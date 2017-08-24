#!/bin/bash

SHELL_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DSPACE_HOME_DIR="$( cd $SHELL_SCRIPT_DIR/../.. && pwd )"

echo "SHELL_SCRIPT_DIR = $SHELL_SCRIPT_DIR"
echo "DSPACE_HOME_DIR  = $DSPACE_HOME_DIR"

function exec_cmd() {
   local CMD="$1"
   echo "EXEC: $CMD\n"
   local OUT=$(eval $CMD)
}

exec_cmd "chgrp -R dspace $DSPACE_HOME_DIR 2>/dev/null"
exec_cmd "find $DSPACE_HOME_DIR -type f -exec chmod 664 {} \\;";
exec_cmd "find $DSPACE_HOME_DIR -type d -exec chmod 2775 {} \\;";
exec_cmd "find $DSPACE_HOME_DIR/campusrepo/bin -type f -exec chmod 775 {} \\;";
exec_cmd "find $DSPACE_HOME_DIR/src/dspace/bin -type f -exec chmod 775 {} \\;";
