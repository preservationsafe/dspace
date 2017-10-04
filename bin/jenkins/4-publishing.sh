echo "PUBLISHING $JOB_BASE_NAME"

. run/build-tag.sh

docker tag dspace6-dev:$SRC_TAG dockerepo.library.arizona.edu:5000/dspace6-dev:$SRC_TAG

docker push dockerepo.library.arizona.edu:5000/dspace6-dev:$SRC_TAG

docker rmi dockerepo.library.arizona.edu:5000/dspace6-dev:$SRC_TAG

docker image rm dspace6-dev:$SRC_TAG

git push origin $SRC_TAG
