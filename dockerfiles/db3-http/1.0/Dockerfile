#
# Create an empty shell to stuff in OS tarball

#
FROM db3-import

# Add back in runtime directories
RUN \
mkdir -p /run && chmod 777 /run

# Clean out un-needed files
RUN \
rm -fr /var/log/mysql && \
rm -fr /var/log/httpd/* && \
rm -fr /data1/uairlogs/*

# Remove files that have important passwords
RUN \
rm -fr /root/automysqlbackup.sh \
rm -fr /proc/1443/cmdline

# Will target apache to run as user apache, allow log permissions
RUN \
chmod  777 /var/run && \
chmod  777 /tmp/phpsess && \
chown -R apache.apache /etc/pki && \
chown -R apache.apache /var/log/httpd && \
chown -R apache.apache /data1/uairlogs && \
chown -R apache.apache /var/run/httpd.pid

# Add user webadmin to apache group
#RUN \
#gpasswd -a wwwadmin apache

# Overlay sanitized apache conf, .htaccess, db.ini created from 3-db3-sanitize-http.sh
ADD htaccess-sanitized.tar.gz /

# Overlay mysql localhost -> db-host files created from 4-db3-sanitize-mysql.sh
ADD mysql-sanitized.tar.gz /

USER apache

# Have container startup in root user with bash
ENTRYPOINT ["/usr/sbin/apachectl", "-DFOREGROUND" ]
