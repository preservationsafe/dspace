#!/bin/bash
set -x

# Script built from info at https://wiki.duraspace.org/display/DSDOC6x/AIP+Backup+and+Restore#AIPBackupandRestore-RestoringEntireSite

. "$( dirname "${BASH_SOURCE[0]}" )/get-dspace-home-dir.sh"

DATETIME=`date +%Y-%m-%d.%H.%M.%S`
OUTPUT_DIR_BASE="${1:-.}"
OUTPUT_SITE=${2:-dspace-site-aip}
DSPACE_SITE_HANDLE=${3:-123456789/0}
EMAIL="$4"
OUTPUT_DIR="$OUTPUT_DIR_BASE/$OUTPUT_SITE-$DATETIME"

if [ "$EMAIL" == "" ]; then
   EMAIL=`git config --get --global user.email`
fi

mkdir -p $OUTPUT_DIR

$DSPACE_HOME_DIR/dspace-install/bin/dspace packager -d -a -t AIP -e $EMAIL -i $DSPACE_SITE_HANDLE $OUTPUT_DIR/$OUTPUT_SITE.zip
