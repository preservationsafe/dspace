#!/bin/sh


DB_HOST=${1:-localhost}
DB_USER=dspace6dba
DB_PASSWORD=dspace6D5vops-G5tt62
export PGPASSWORD="$DB_PASSWORD"

psql -h $DB_HOST -U $DB_USER -d dspace
