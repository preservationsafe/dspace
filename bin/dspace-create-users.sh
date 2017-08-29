#!/bin/sh
groupadd dspace --gid 800
useradd dspace --uid 800 --gid 800 --home /dspace --shell /bin/bash
adduser docker dspace
adduser -uid 1000 dspace
usermod -a -G dspace docker
usermod -a -G docker,glbrimhall dspace


