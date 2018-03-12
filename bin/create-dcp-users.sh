#!/bin/bash

if [ "${BASH_VERSINFO}" -lt 4 ]; then
    echo "This script requires bash 4.0 or greater."
    exit 1
fi

declare -A SUDOLIST

GROUPLIST="docker,sudo"

SUDOLIST=( \
    ["rgrunloh"]="Robert Grunloh" \
    ["turmanj"]="Jeff Turman" \
    ["BrittanyRothengatter"]="Brittany Rothengatter" \
    ["mhagedon"]="Mike Hagedon" \
    ["simpsonw"]="William Simpson" \
    ["enazar"]="Elia Nazarenko" \
    ["cao89"]="Andy Osborne" \
    ["inolan"]="Isaiah Nolan" \
    ["glbrimhall"]="Geoff Brimhall" \
    ["buildmeister"]="Build Meister" \
    )

for USER in ${!SUDOLIST[@]}; do
  if [ "`id $USER 2>/dev/null`" = "" ]; then
    useradd -m --shell /bin/bash -G "$GROUPLIST" -c "${SUDOLIST[$USER]}" $USER
    echo "asdf\nasdf" | passwd $USER
  else
    usermod -a -G "$GROUPLIST" $USER
  fi
done

gpasswd -d buildmeister sudo
