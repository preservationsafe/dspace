Conditional Step(single)
Run? Always
Builder: Execute Shell

echo "CLEANING $JOB_BASE_NAME $SRC_TAG"

docker rm -f build-dspace6-tst || echo "already removed"
docker image rm dockerepo.library.arizona.edu:5000/dspace6-dev:$SRC_TAG || echo "already removed"
docker image rm dockerepo.library.arizona.edu:5000/dspace6-tst:$SRC_TAG || echo "already removed"
docker image rm dspace6-dev:$SRC_TAG || echo "already removed"
docker image rm dspace6-tst:$SRC_TAG || echo "already removed"

