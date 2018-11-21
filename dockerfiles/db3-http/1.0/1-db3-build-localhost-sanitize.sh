#!/bin/sh

if [ "$1" == "RESEARCH" ]; then
   find /data1 -name \*.php -exec grep --color=always -Hn -A 1 -B 1 localhost {} \;
   # 127.0.0.1 is used for "allowed IP" filters, not db connectivity
   #find /data1 -name \*.php -exec grep --color=always -Hn -A 1 -B 1 127.0.0.1 {} \;
   exit
fi

# Run this script within the db3 docker container to build the list of files
# which need port 80/443 to localhost 6080/6443 sanitization:

rm -f /htaccess.list
find /data1 -name .htaccess -exec grep -l digital {} \; >> /htaccess.list.tmp
find /data1 -name .htaccess -exec grep -l 80 {} \; >> /htaccess.list.tmp
find /data1 -name .htaccess -exec grep -l 443 {} \; >> /htaccess.list.tmp
find /data1 -name db.ini >> /htaccess.list.tmp
find /data1 -name myConfig.php >> /htaccess.list.tmp
grep -l 80 /etc/httpd/*/*.conf >> /htaccess.list.tmp
grep -l 443 /etc/httpd/*/*.conf >> /htaccess.list.tmp
sort -u /htaccess.list.tmp > /htaccess.list
rm /htaccess.list.tmp
cd /
tar -cvzf /htaccess.tar.gz -T /htaccess.list
cd -

# Cleanup mysql localhost access, will eventually map localhost -> db-host
rm -f /mysql.list
find /data1 -name \*.php -not -path "*/tests/*" -not -path "*/test/*" -exec grep -l localhost {} \; >> /mysql.list.tmp
#find /data1 -name \*.php -not -path "*/tests/*" -not -path "*/test/*" -exec grep -l 127.0.0.1 {} \; >> /mysql.list.tmp
sort -u /mysql.list.tmp > /mysql.list
rm /mysql.list.tmp
cd /
tar -cvzf mysql.tar.gz -T /mysql.list
cd -
