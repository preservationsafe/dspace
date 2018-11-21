
FROM ubuntu-nginx:1.0

MAINTAINER Geoff Brimhall <glbrimhall@email.arizona.edu>

# Update configuration
RUN rm -f /etc/nginx/conf.d/*
ADD proxy-80.conf /etc/nginx/conf.d
ADD proxy-443.conf /etc/nginx/conf.d
