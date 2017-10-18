#!/bin/sh


DB_HOST=${1:-repository-dbdev}
DB_USER=postgresdba
DB_PASSWORD=postgresD5vops-G5tt.62
export PGPASSWORD="$DB_PASSWORD"

psql -h $DB_HOST -U $DB_USER -c "CREATE USER dspaceDBA WITH PASSWORD 'dspaceD5vops-G5tt62'"
psql -h $DB_HOST -U $DB_USER -c "CREATE DATABASE dspace OWNER dspaceDBA ENCODING 'UNICODE'"
