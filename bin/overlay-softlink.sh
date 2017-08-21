#!/bin/bash

SRCDIR=${1%/}
DSTDIR=${2%/}

if [ ! -d "$SRCDIR" ]; then
    echo "ERROR: src dir $SRCDIR does not exist"
    exit 1
fi

if [ ! -d "$DSTDIR" ]; then
    echo "ERROR: dst dir $DSTDIR does not exist"
    exit 1
fi

function traverse() {
   local SRC="$1"
   local DST="$2"
   local DEPTH="$3"

   echo "cd $DST ; ln -s $DEPTH/$SRC/* . 2>/dev/null; cd - >/dev/null"
   cd "$DST" ; ln -s "$DEPTH"/"$SRC"/* . 2>/dev/null; cd - >/dev/null
   #rm -f "$DST/"\*

   for file in $(ls "$SRC")
   do
       if [ -d "${SRC}/${file}" ] && [ ! -L "${DST}/${file}" ] && [ -d "${DST}/${file}" ]; then
               traverse "${SRC}/${file}" "${DST}/${file}" "$DEPTH/.."
       fi
   done
}

traverse "$SRCDIR" "$DSTDIR" ".."
