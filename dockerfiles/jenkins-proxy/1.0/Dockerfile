
FROM dockerepo.library.arizona.edu:5000/ubuntu-nginx:1.0

MAINTAINER Geoff Brimhall <glbrimhall@email.arizona.edu>

# Update /etc/nginx/conf.d configuration
RUN rm -fr /etc/nginx/conf.d
ADD conf.d /etc/nginx/conf.d

# Update /etc/nginx/certs configuration
RUN rm -fr /etc/nginx/certs
ADD certs  /etc/nginx/certs
