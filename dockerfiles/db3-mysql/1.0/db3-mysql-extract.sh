#!/bin/sh

# This takes too long to load the 19GB tarball and extract
#tar -xvf ../db3-import/db3.tar -T db3-mysql.list

# Extract from running docker container containing the tarball:
TMPDIR=tmp
mkdir -p $TMPDIR/var/lib
mkdir -p $TMPDIR/etc

docker cp http-db3:/var/lib/mysql $TMPDIR/var/lib
docker cp http-db3:/etc/my.cnf $TMPDIR/etc

cd $TMPDIR
tar -czf ../db3-mysql.tar.gz *
cd ..
rm -f $TMPDIR
