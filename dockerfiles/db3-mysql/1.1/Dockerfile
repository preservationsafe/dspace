#
# ruwen/mysql-server-5.0 happens to be based off same CentOS/Mysql
# as db3
#
FROM db3-mysql:1.0

USER root

# Add script to run mysql read-only:
ADD init-mysql.sql /

USER mysql

CMD [ "mysqld_safe", "--init-file=/init-mysql.sql" ]
