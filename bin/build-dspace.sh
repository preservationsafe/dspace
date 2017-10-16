#!/bin/bash

ENV=${1:-dev}

if [ "$HOME" == "/opt/tomcat/dspace" ]; then
  DSPACE_HOME_DIR="$HOME"
else
  SHELL_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  DSPACE_HOME_DIR="$( cd $SHELL_SCRIPT_DIR/.. && pwd )"
  while [ ! -d "$DSPACE_HOME_DIR/overlay" ]; do
      DSPACE_HOME_DIR="$( cd $DSPACE_HOME_DIR/.. && pwd )"
  done
fi

DSPACE_SRC="$DSPACE_HOME_DIR/src"
DSPACE_RUN="$DSPACE_HOME_DIR/run"
DSPACE_OVR="$DSPACE_HOME_DIR/overlay"
DSPACE_SRC_RELEASE="dspace-6.2-src-release"
SELENIUM_IMAGE="selenium/standalone-firefox:2.53.0";

if [ "$1" == "clean" ]; then
  rm -rf $DSPACE_SRC/* && rm -rf $DSPACE_RUN/*
  cd $DSPACE_HOME_DIR && ssh vitae "cat /data1/vitae/repos/$DSPACE_SRC_RELEASE.tar.gz" | tar -xzf - \
    && mv $DSPACE_SRC_RELEASE/* src && rmdir $DSPACE_SRC_RELEASE
  cd $DSPACE_HOME_DIR && bin/fix-permissions.sh
  exit
fi

if [ "$1" != "install" ]; then
  # Pickup latest overlays
  if [ ! -e $DSPACE_SRC/dspace/config/local.cfg-dev ]; then
    cd $DSPACE_HOME_DIR && bin/overlay-softlink.sh overlay src
  fi
  # Assume building for the dev environment
  if [ ! -e $DSPACE_SRC/dspace/config/local.cfg ]; then
    # mvn test cannot use softlink'd pom.xml  
    cp -f $DSPACE_OVR/dspace/modules/jspui/pom.xml $DSPACE_SRC/dspace/modules/jspui/pom.xml
    cp $DSPACE_SRC/dspace/config/local.cfg-dev $DSPACE_SRC/dspace/config/local.cfg
    # Do not enable this - install will not pick up the soft link'd files
    # and mvn test breaks if dependant files are softlinks !
    #cd $DSPACE_HOME_DIR && bin/overlay-config.pl $ENV src/dspace/config
  fi

  # Build dspace:
  cd $DSPACE_SRC && mvn package
fi
  
# Install dspace:
cd $DSPACE_SRC/dspace/target/dspace-installer && ant fresh_install
cd $DSPACE_HOME_DIR && bin/overlay-softlink.sh overlay/dspace/config run/config

# Test dspace:
if [ "$1" == "test" ]; then
    TESTLIST=${2:-*,!PoiWordFilterTest}
    cd $DSPACE_SRC && mvn test -Dmaven.test.skip=false -DskipITs=false -DfailIfNoTests=false -Dtest="$TESTLIST"
fi
