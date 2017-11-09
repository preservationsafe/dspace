#!/bin/bash
set -x

# Script built from info at https://wiki.duraspace.org/display/DSDOC6x/AIP+Backup+and+Restore#AIPBackupandRestore-RestoringEntireSite

. "$( dirname "${BASH_SOURCE[0]}" )/get-dspace-home-dir.sh"

IMPORT_SITE_AIP="${1}"
DSPACE_SITE_HANDLE=${2:-123456789/0}
EMAIL="$3"

if [ "$EMAIL" == "" ]; then
   EMAIL=`git config --get --global user.email`
fi

if [ ! -f "$IMPORT_SITE_AIP" ]; then
    echo "MISSING: $IMPORT_SITE_AIP, exiting..."
    exit 1
fi

export JAVA_OPTS="\
-Xms2048m \
-Xmx4096m \
-XX:PermSize=256m \
-XX:MaxPermSize=512m"

$DSPACE_HOME_DIR/dspace-install/bin/dspace packager -r -a -f -t AIP -e $EMAIL -i $DSPACE_SITE_HANDLE "$IMPORT_SITE_AIP"

echo "If the import was not clean, make sure to run to reset:"
echo "   $DSPACE_HOME_DIR/dspace-install/bin/dspace cleanup -v"
