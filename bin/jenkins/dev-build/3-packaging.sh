echo "PACKAGING $JOB_BASE_NAME"

. run/build-tag.sh

docker build --rm=true -t dspace6-dev:$SRC_TAG -f bin/Dockerfile-dev .
