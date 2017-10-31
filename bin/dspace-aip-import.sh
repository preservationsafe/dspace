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

$DSPACE_HOME_DIR/run/bin/dspace packager -r -a -f -t AIP -e $EMAIL -i $DSPACE_SITE_HANDLE "$IMPORT_SITE_AIP"
