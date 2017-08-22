#!/bin/sh

DB_HOST=${1:-dspace-dbdev}
DB_USER=postgresDBA
DB_PASSWORD=postgresD5vops-G5tt.62
export PGPASSWORD="$DB_PASSWORD"

psql -h $DB_HOST -U $DB_USER -c "CREATE USER dspace6DBA WITH PASSWORD 'dspace6D5vops-G5tt62'"
psql -h $DB_HOST -U $DB_USER -c "CREATE DATABASE dspacedev OWNER dspace6DBA ENCODING 'UNICODE'"
psql -h $DB_HOST -U $DB_USER dspacetst -c "CREATE EXTENSION pgcrypto;"
