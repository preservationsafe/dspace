. dspace-install/build-tag.sh

echo "PACKAGING $JOB_BASE_NAME $SRC_TAG"

docker build --rm=true -t dspace6-dev:$SRC_TAG -f bin/Dockerfile-dev .
