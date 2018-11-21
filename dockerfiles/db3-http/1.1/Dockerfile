#
# Create an empty shell to stuff in OS tarball

#
FROM db3-http:1.0

USER root

# Add back in runtime directories
RUN \
mkdir -p /mnt/s18d1

USER apache

# Have container startup in root user with bash
#CMD /bin/bash
ENTRYPOINT ["/usr/sbin/apachectl", "-DFOREGROUND" ]
