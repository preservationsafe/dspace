#!/bin/sh
mkdir tmpdb
cd tmpdb
tar -xzvf ../mysql.tar.gz
cd ..

# Have mysql connection to localhost be routed to "db-host"
find tmpdb -type f | xargs sed -i "s/localhost/db-host/g"

cd tmpdb
tar -czvf ../mysql-sanitized.tar.gz *
cd ..
