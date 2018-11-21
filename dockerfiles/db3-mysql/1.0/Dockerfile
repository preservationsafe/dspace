#
# ruwen/mysql-server-5.0 happens to be based off same CentOS/Mysql
# as db3
#
FROM ruwen/mysql-server-5.0

USER root
WORKDIR /

# Remove orig mysql stuff
RUN \
rm -fr /etc/my.cnf && \
rm -fr /var/lib/mysql

# Put in db3's mysql content
# This tarball was created from db3-mysql-extract.sh
ADD db3-mysql.tar.gz /

# Add script to run mysql read-only:
ADD init-mysql.sql /

RUN \
chown -R mysql.mysql /var/lib/mysql

USER mysql

CMD [ "mysqld_safe", "--init-file=/init-mysql.sql" ]
