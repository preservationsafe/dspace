#
# Create an empty shell to stuff in OS tarball

#
FROM firstfolio-import

# Add back in runtime directories
RUN \
mkdir -p /run && chmod 777 /run && chmod -R 777 /var/log/apache2

# Add user www-data to wwwadmin group
RUN \
gpasswd -a www-data webadmin

# Change port 80 to run on 6080
RUN \
sed -i "s/80>/6080>/g" /etc/apache2/sites-available/000-default.conf && \
sed -i "s/Listen 80/Listen 6080/g" /etc/apache2/ports.conf

# Change port 443 to run on 6443
RUN \
sed -i "s/443>/6443>/g" /etc/apache2/sites-available/default-ssl.conf && \
sed -i "s/Listen 443/Listen 6443/g" /etc/apache2/ports.conf

USER www-data

# Have container startup in root user with bash
#CMD /bin/bash
ENTRYPOINT ["/usr/sbin/apachectl", "-DFOREGROUND" ]
