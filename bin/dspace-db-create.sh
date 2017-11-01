#!/bin/sh

DB_HOST=${1:-repository-dbdev}
DB_SUPER_ADMIN=${2:-postgresDBA}
DB_SUPER_PSWD=${3:-postgresD5vops-G5tt.62}
DB_DSPACE_ADMIN=dspace6DBA
DB_DSPACE_INSTANCE=dspacedev

export PGPASSWORD="$DB_SUPER_PSWD"

psql -h $DB_HOST -U $DB_SUPER_ADMIN -c "CREATE USER $DB_DSPACE_ADMIN WITH PASSWORD 'dspace6D5vops-G5tt62'"
psql -h $DB_HOST -U $DB_SUPER_ADMIN -c "CREATE DATABASE $DB_DSPACE_INSTANCE OWNER $DB_DSPACE_ADMIN ENCODING 'UNICODE'"
psql -h $DB_HOST -U $DB_SUPER_ADMIN $DB_DSPACE_INSTANCE -c "CREATE EXTENSION pgcrypto;"
