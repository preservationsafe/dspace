Run? Always
Builder: Execute shell

. dspace-install/build-tag.sh

echo "CLEANING $JOB_BASE_NAME $SRC_TAG"

docker image rm dspace6-dev:$SRC_TAG
