#!/bin/sh

DB_DIR=${1:-sql}
DB_HOST=${2:-localhost}
DB_NAME=dspacedev
DB_USER=dspace6dba
DB_PASSWORD=dspace6D5vops-G5tt62
export PGPASSWORD="$DB_PASSWORD"

for SQL in `ls $DB_DIR`; do
   FILE="$DB_DIR/$SQL"
   echo "PROCESSING: $FILE"
   psql -h $DB_HOST -U $DB_USER -d $DB_NAME -f $FILE
done

