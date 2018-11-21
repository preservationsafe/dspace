docker exec "build-$JOB_BASE_NAME-php5-dev" /bin/bash -c "composer install -d /home/buildmeister/src"
docker exec "build-$JOB_BASE_NAME-php5-dev" /bin/bash -c "cd /home/buildmeister/src && vendor/bin/phing jenkins -logger phing.listener.AnsiColorLogger"
