echo "PACKAGING $JOB_BASE_NAME $SRC_TAG"

docker commit "build-dspace6-tst" dspace6-tst:$SRC_TAG
