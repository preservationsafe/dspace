project name: dspace-tst-build
This project is parameterized
String Parameter SRC_TAG
Default Value: unknown

Prepare an environment for the run
Keep Jenkins Environment Variables
Keep Jenkns Build Variables
Script Content:

docker network create --driver bridge $JOB_BASE_NAME || echo "network exists"
