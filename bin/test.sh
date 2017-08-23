#!/bin/sh

CMD="id | grep docker"
OUT=$(eval $CMD)
echo "CMD: $CMD returned $OUT"
