#!/bin/bash

STEP=${1:-build}

. "$( dirname "${BASH_SOURCE[0]}" )/get-dspace-home-dir.sh"

DSPACE_SRC="$DSPACE_HOME_DIR/dspace"
DSPACE_RUN="$DSPACE_HOME_DIR/dspace-install"
SELENIUM_IMAGE="selenium/standalone-firefox:2.53.0";

if [ "$STEP" == "reset" ]; then
  rm -rf $DSPACE_RUN/*
  cd $DSPACE_HOME_DIR && bin/fix-permissions.sh
  exit
fi

if [ "$STEP" == "clean" ]; then
  cd $DSPACE_HOME_DIR && ant clean
  exit
fi

if [ "$STEP" == "build" ]; then
  cd $DSPACE_HOME_DIR && ant build_init
fi
  
# Test dspace:
if [ "$STEP" == "test" ]; then
    TESTLIST=${2:-*,!PoiWordFilterTest}
    cd $DSPACE_SRC && mvn test -Dmaven.test.skip=false -DskipITs=false -DfailIfNoTests=false -Dtest="$TESTLIST"
fi
