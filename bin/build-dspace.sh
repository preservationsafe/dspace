#!/bin/bash

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
DSPACE_SRC_RELEASE="dspace-6.2-src-release"

if [ "$1" == "clean" ]; then
  rm -rf $DSPACE_SRC/* && rm -rf $DSPACE_RUN/*
  cd $DSPACE_HOME_DIR && ssh vitae "cat /data1/vitae/repos/$DSPACE_SRC_RELEASE.tar.gz" | tar -xzf - \
    && mv $DSPACE_SRC_RELEASE/* src && rmdir $DSPACE_SRC_RELEASE
  cd $DSPACE_HOME_DIR && bin/fix-permissions.sh
  exit
fi

if [ "$1" != "install" ]; then
  # Pickup latest overlays
  cd $DSPACE_HOME_DIR && bin/overlay-softlink.sh overlay src

  # Default to a dev build
  if [ ! -f "$DSPACE_SRC/dspace/config/local.cfg" ]; then
      cp $DSPACE_SRC/dspace/config/local.cfg-dev $DSPACE_SRC/dspace/config/local.cfg
      cd $DSPACE_HOME_DIR && bin/overlay-config.pl dev src/dspace/config
  fi

  # Build dspace:
  cd $DSPACE_SRC && mvn package
fi
  
# Install dspace:
cd $DSPACE_SRC/dspace/target/dspace-installer && ant fresh_install

if [ ! -f "$DSPACE_RUN/config/local.cfg-dev" ]; then
  cd $DSPACE_HOME_DIR && bin/overlay-softlink.sh overlay/dspace/config run/config
fi
