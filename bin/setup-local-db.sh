#!/bin/sh

# READ HERE FIRST!
# TODO: Streamline this script (or make into documentation only) once process works for everyone. In the meantime have some comments....
# 
# Prereqs:
#     * Have postgres 9.6 installed on your system and know your password for the postgres user (or have no password)
#        * https://www.postgresql.org/download/ for downloads. Grab the 9.6 version for your OS
#     * Have the NFS share mounted and available on your machine (assumed location of /opt/tomcat/assetstore, change if that location is different)
#        * Copied from Geoff's install script...
#              "Make sure you have an NFS client installed (\"sudo apt-get install nfs-common\" on Ubuntu-based systems), then try running the commands (on linux):"
#              "sudo cp /etc/fstab /etc/fstab.bak"
#              "sudo mkdir -p /mnt/dspace-assetstore"
#              "sudo chown dspace.dspace /mnt/dspace-assetstore"
#              "sudo echo "qnas1.library.arizona.edu:/dspace-assetstore-dev /mnt/dspace-assetstore nfs nfsvers=3,proto=tcp,hard 0 0" >> /etc/fstab"
#              "sudo mount /mnt/dspace-assetstore"
#
# Below may be changing based on how we will extende the local.cfg file, keep in mind
# Following this script's completion, the only config change that needs to be made is the db.url line in local.cfg 
# Comment out old shared DB info and add new line 'db.url = jdbc:postgresql://localhost:5432/dspacelocal'
#
#
# If script fails part way through, will need to remove the DB user created in the first step with 'dropuser dspacedba' and the DB with 'dropdb dspacelocal' (may need pstgres password again for that cmd) in order to rerun
# Also if script fails AFTER the assetstoreShared is created and the empty dir assetstore is created, skip those parts and just run the cp command at the end.

      


TOMCAT=/opt/tomcat # Location of local tomcat install directory where the shared assetstore is available (softlinked from /mnt/dspace-assetstore), update if different
DB_HOST=${1:-repository-dbdev.library.arizona.edu} # Shared DB host (cannot be changed)
DB_USER_CREATE=postgres #The super user for postgres created during install. May or may not have a password set, make note of which. (Can be changed to any postgres superuser)
DB_USER_BACKUP=dspacedba #The shared DB user needed to access the assetstore (cannot be changed)
DB_PASSWORD=dspaceD5vops-G5tt62 #The shared DB user password needed to access the assetstore (cannot be changed)
DB_SHARED=dspacetst #The shared DB name (cannot be changed)
DB_LOCAL=dspacelocal #Your local DB name (can be changed if preferrable)
DB_BACKUP_FILE=dspacetstBackup.sql # Name of file to do the PG_DUMP into (can be changed if preferrable)
ASSET_STORE_SHARED=assetstoreShared # Name of shared assetstore to allow for future referencing if needed (can be changed if preferrable)
ASSET_STORE_LOCAL=assetstore # Name of local assetstore (should stay the same name to avoid config changes in local.cfg)


# Create the postgres user and DB on local machine to be used for DSpace development. 
# NOTE: Will be prompted twice for the new user password, remember this... and prompted to enter the superuser password to confirm you are authorized to complete this action
# If user is already created can skip this or run: 'dropuser $DB_USER_BACKUP' if you have the dropuser cmd installed (came with my postgres install automatically) or log in as the superuser and run 'DROP USER $DB_USER_BACKUP'
createuser --username=$DB_USER_CREATE --no-superuser --pwprompt $DB_USER_BACKUP

# Use 1st line if postgres user has no password set or edit second line to have correct password if postgres user has a password set
# NOTE: Very important to keep this DB 100% clean and empty. DO NOT hook up DSpace BEFORE completing the import... it will fail.
# If DB is already created can skip this or run: 'dropdb $DB_LOCAL' if you have the dropdb cmd installed (came with my postgres install automatically) or log in as superuser and run 'DROP DATABASE $DB_LOCAL'
createdb --username=$DB_USER_CREATE --owner=$DB_USER_BACKUP --encoding=UNICODE $DB_LOCAL
# PGPASSWORD="postgresUserPassword" createdb --username=$DB_USER_CREATE --owner=$DB_USER_BACKUP --encoding=UNICODE $DB_LOCAL

# Add pgcrypto extension to the local DSpace development postgres DB
# Use 1st line if postgres user has no password set or edit second line to have correct password if postgres user has a password set
psql --username=$DB_USER_CREATE $DB_LOCAL -c "CREATE EXTENSION pgcrypto;"  
# PGPASSWORD="postgresUserPassword" psql --username=$DB_USER_CREATE $DB_LOCAL -c "CREATE EXTENSION pgcrypto;"  

# Export the metadata from the shared DB hosted on qnas1
PGPASSWORD=$DB_PASSWORD pg_dump -h $DB_HOST -U $DB_USER_BACKUP $DB_SHARED > $DB_BACKUP_FILE   

# Import the metadata into the new local DSpace development postgres DB
# NOTE: PG_RESTORE does not work as the backup is done as a text-based file and psql has to be used. Also should produce long list of output from successful import of tables.... if do not see this before the assetstore copy starts check for error
# Use one or the other...
# For macOS
# cat $DB_BACKUP_FILE | psql $DB_LOCAL
# For Linux users
psql -U $DB_USER_BACKUP $DB_LOCAL < $DB_BACKUP_FILE


# CD to the tomcat folder and rename the shared assetstore to avoid having to make configuration file changes with new local one
cd $TOMCAT 
mv $ASSET_STORE_LOCAL $ASSET_STORE_SHARED

# Create local assetstore with original directory name and copy files from shared assetstore to local directory. 
# This may take some time to complete and verbose flag is turned on to show output (~30-40 minutes with regular output)
# If 1st cp line does not work, try the commented out either in here or manually paste into CLI
mkdir $ASSET_STORE_LOCAL 
cp -vR $ASSET_STORE_SHARED/* $ASSET_STORE_LOCAL
# cp -vR assetstoreShared/* assetstore







