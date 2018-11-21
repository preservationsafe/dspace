#!/bin/sh
mkdir tmp
cd tmp
tar -xzvf ../htaccess.tar.gz
cd ..

# Have http listen on non-standard port 6080
find tmp -type f -exec grep -l 80 {} \; | xargs sed -i "s/\b80\b/6080/g"
# Have https listen on non-standard port 6443
find tmp -type f -exec grep -l 443 {} \; | xargs sed -i "s/\b443\b/6443/g"

# Sanitize domain and ip to localhost
find tmp -type f -exec grep -l 150.135.239.40 {} \; | xargs sed -i "s/150.135.239.40/localhost/g"
find tmp -type f -exec grep -l 150.135.239.4 {} \; | xargs sed -i "s/150.135.239.4/localhost/g"
find tmp -type f -exec grep -l 150.135.239.6 {} \; | xargs sed -i "s/150.135.239.6/localhost/g"
find tmp -type f -exec grep -l digital {} \; | xargs sed -i "s/www.digitalcommons.arizona.edu/localhost/g"
find tmp -type f -exec grep -l digital {} \; | xargs sed -i "s/www.digitalcommons.library.arizona.edu/localhost/g"
find tmp -type f -exec grep -l digital {} \; | xargs sed -i "s/digitalcommons.library.arizona.edu/localhost/g"
find tmp -type f -exec grep -l digital {} \; | xargs sed -i "/etc\/pki/! s/digitalcommons.arizona.edu/localhost/g"

# Disable https - have https port be cleartext
#find tmp -type f -exec grep -l SSL {} \; | xargs sed -i "s/^\( *\)SSL/\1#SSL/g"

# Have redirects of http listen on non-standard port 6080
#find tmp -type f -exec grep -l http: {} \; | xargs sed -i "s/http:\/\/localhost/http:\/\/localhost:6080/g"

# Have redirects of https listen on non-standard port 6443
#find tmp -type f -exec grep -l https: {} \; | xargs sed -i "s/https:\/\/localhost/http:\/\/localhost:6443/g"

cd tmp
tar -czvf ../htaccess-sanitized.tar.gz *
cd ..
