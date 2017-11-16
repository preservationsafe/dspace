#!/bin/sh
set -x

DB_MODE_OPTS="CREATE|DELETE|IMPORT|EXPORT"
DB_MODE=${1:-CREATE}

DB_DSPACE_INSTANCE_OPTS="dspacedev|dspacetst|dspacestg"
DB_DSPACE_INSTANCE=${2:-dspacedev}

DB_HOST=${3:-localhost}
DB_DUMP_SQL=${4:-dspacetst.sql}
DB_SUPER_ADMIN=${5:-postgresDBA}
DB_SUPER_PSWD=${6:-postgresD5vops-G5tt.62}

# Right now all exports come from the tst environment
if [ "$DB_MODE" = "EXPORT" ]; then
  DB_DSPACE_INSTANCE="dspacetst"
fi

# Setup credentials based on the environment

if [ "$DB_DSPACE_INSTANCE" = "dspacedev" ]; then
  DB_DSPACE_ADMIN=dspace6dba
  DB_DSPACE_PSWD="dspace6D5vops-G5tt62"
else
if [ "$DB_DSPACE_INSTANCE" = "dspacetst" ]; then
  DB_DSPACE_ADMIN=dspacedba
  DB_DSPACE_PSWD="dspaceD5vops-G5tt62"
else
if [ "$DB_DSPACE_INSTANCE" = "dspacestg" ]; then
  DB_DSPACE_ADMIN=dspacedbastg
  DB_DSPACE_PSWD="dspaceD3zstg-G5tt62"
fi
fi
fi

if [ "$DB_MODE" = "CREATE" ]; then
    
export PGPASSWORD="$DB_SUPER_PSWD"
psql -h $DB_HOST -U $DB_SUPER_ADMIN -c "CREATE USER $DB_DSPACE_ADMIN WITH PASSWORD '$DB_DSPACE_PSWD'"
psql -h $DB_HOST -U $DB_SUPER_ADMIN -c "CREATE DATABASE $DB_DSPACE_INSTANCE OWNER $DB_DSPACE_ADMIN ENCODING 'UNICODE'"
psql -h $DB_HOST -U $DB_SUPER_ADMIN $DB_DSPACE_INSTANCE -c "CREATE EXTENSION pgcrypto;"

else
if [ "$DB_MODE" = "DELETE" ]; then
    
export PGPASSWORD="$DB_SUPER_PSWD"
psql -h $DB_HOST -U $DB_SUPER_ADMIN -c "DROP DATABASE $DB_DSPACE_INSTANCE"

else
if [ "$DB_MODE" = "EXPORT" ]; then

# repository-tst credentials
DB_HOST=repository-dbdev.library.arizona.edu
DB_DSPACE_ADMIN=dspacedba
DB_DSPACE_PSWD="dspaceD5vops-G5tt62"
DB_DSPACE_DEV_INSTANCE="$DB_DSPACE_INSTANCE"
DB_DSPACE_INSTANCE=dspacetst

export PGPASSWORD="$DB_DSPACE_PSWD"
pg_dump -h $DB_HOST -U $DB_DSPACE_ADMIN $DB_DSPACE_INSTANCE > $DB_DUMP_SQL

else
if [ "$DB_MODE" = "IMPORT" ]; then
    
export PGPASSWORD="$DB_DSPACE_PSWD"
psql -h $DB_HOST -U $DB_DSPACE_ADMIN $DB_DSPACE_INSTANCE < $DB_DUMP_SQL

fi
fi
fi
fi
