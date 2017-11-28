#!/bin/bash

STEP=${1:-build}
ENV=${2:-dev}

. "$( dirname "${BASH_SOURCE[0]}" )/get-dspace-home-dir.sh"

DSPACE_SRC="$DSPACE_HOME_DIR/dspace"
DSPACE_RUN="$DSPACE_HOME_DIR/dspace-install"
SELENIUM_IMAGE="selenium/standalone-firefox:2.53.0";

if [ "$STEP" == "reset" ]; then
  echo -n "DELETING: " && rm -vrf $DSPACE_RUN/*
  echo -n "DELETING: " && rm -vf "$DSPACE_HOME_DIR/build.properties"
  cd $DSPACE_HOME_DIR && bin/fix-permissions.sh
  exit
fi

if [ "$STEP" == "clean" ]; then
  cd $DSPACE_HOME_DIR && ant clean
  exit
fi

if [ "$STEP" == "env" ]; then
  echo -n "COPY: " && cp -vf "$DSPACE_HOME_DIR/bin/env/build.properties-$ENV" "$DSPACE_HOME_DIR/build.properties"
  cd $DSPACE_HOME_DIR && ant copy_local_config
  echo "cp -vf $DSPACE_SRC/config/local.cfg $DSPACE_RUN/config/local.cfg"
  echo -n "COPY: " && cp -vf "$DSPACE_SRC/config/local.cfg" "$DSPACE_RUN/config/local.cfg"
  exit
fi

if [ "$STEP" == "build" ]; then
    if [ ! -f "$DSPACE_HOME_DIR/build.properties" ]; then
      echo -n "COPY: " && cp -vf "$DSPACE_HOME_DIR/bin/env/build.properties-$ENV" "$DSPACE_HOME_DIR/build.properties"
    fi
  cd $DSPACE_HOME_DIR && ant build_init
fi
  
# Test dspace:
if [ "$STEP" == "test" ]; then
    TESTLIST=${2:-*,!PoiWordFilterTest}
    cd $DSPACE_SRC && mvn test -Dmaven.test.skip=false -DskipITs=false -DfailIfNoTests=false -Dtest="$TESTLIST"
fi
