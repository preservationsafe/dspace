docker pull xqdocker/ubuntu-mysql-5.5
docker pull dockerepo.library.arizona.edu:5000/php5-dev:1.0

docker network create --driver bridge $JOB_BASE_NAME || echo "network exists"

#mkfifo -m 777 /tmp/build-$JOB_BASE_NAME-mysql-fifo || echo "socket exists"
#  -v /tmp/build-$JOB_BASE_NAME-mysql-fifo:/var/run/mysqld/mysqld.sock \

docker run -d \
--net=$JOB_BASE_NAME \
--name build-$JOB_BASE_NAME-mysql-5.5 \
xqdocker/ubuntu-mysql-5.5 || echo "docker container exists"

docker run -d \
--net=$JOB_BASE_NAME \
-v $JENKINS_HOME/workspace/$JOB_BASE_NAME:/home/buildmeister/src \
-it --entrypoint /bin/bash \
--link build-$JOB_BASE_NAME-mysql-5.5:db-host \
--name build-$JOB_BASE_NAME-php5-dev \
dockerepo.library.arizona.edu:5000/php5-dev:1.0 || echo "docker container exists"

