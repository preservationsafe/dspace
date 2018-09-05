
echo "PUBLISHING $JOB_BASE_NAME $SRC_TAG"

docker tag dspace6-tst:$SRC_TAG dockerepo.library.arizona.edu:5000/dspace6-tst:$SRC_TAG

docker push dockerepo.library.arizona.edu:5000/dspace6-tst:$SRC_TAG
