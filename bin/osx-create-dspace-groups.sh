#!/bin/sh
sudo dseditgroup -o edit -a BrittanyRothengatter -t user docker

sudo dscl . -create /Groups/docker
sudo dscl . -create /Groups/docker name docker
sudo dscl . -create /Groups/docker passwd "docker"
sudo dscl . -create /Groups/docker gid 800
sudo dscl . -create /Groups/docker GroupMembership docker

sudo dseditgroup -o edit -a USERID -t user docker
