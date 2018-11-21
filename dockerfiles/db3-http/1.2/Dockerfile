#
# Create an empty shell to stuff in OS tarball

#
FROM db3-http:1.1

USER root

# Add journal apache rewrites to https://journals.uair.arizona.edu/
ADD virtual.conf /etc/httpd/conf.d

USER apache
