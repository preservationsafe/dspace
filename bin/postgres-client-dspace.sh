#!/bin/sh


DB_HOST=${1:-dspace-dbdev}
DB_USER=dspacedba
DB_PASSWORD=dspaceD5vops-G5tt62
export PGPASSWORD="$DB_PASSWORD"

psql -h $DB_HOST -U $DB_USER -d dspace
