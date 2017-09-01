[Campus Repository Wiki]()
# DSpace Docker Development

## Goal
Review the docker development integration proposals and come to a consensus on how we want to integrate docker into dspace development. Discuss, add, refine the pros and cons with each approach to help come to a consensus.

## Background
When looking over how to build DSpace 6.x through [documentation](https://wiki.duraspace.org/display/DSDOC6x/Installing+DSpace) there are three directories that are involved to build, install, deploy, and run dspace:

* tomcat.dir = location of tomcat, where dspace is run from.
* Dspace.src.dir = root dir location of dspace source tarball exploded (or git clone)
* Dspace.install.dir = directory dspace is installed into once built.

Docker containers are designed to allow mounting host directories into the docker container. Through my experiences working with building and deploying dspace in docker, I have a couple proposals with how we could integrate docker containers into the development phase dspace.

### Development centric
Dspace.src.dir  --> located on developer's host system, mounted into docker image in a standard location. Developers can build the source either on the host *or* in the docker container.

This approach implies:

Dspace.install.dir --> located in docker container, and developers have to execute the 'install' portion of dspace within the docker container

### Release centric
Dspace.src.dir  --> located on developer's host system, mounted into docker image in a standard location. Developers are expected to build the source on their host system.

Dspace.install.dir --> located on the developer's host system, but mounted into the docker container in a standard location. Developers would execute the 'install' portion of building docker on the host system.

Both approaches imply:  
Tomcat.dir --> located in the docker container.

### Pro/Con


#### Development centric

**Pros:**
* The docker image can be designed to contain all developer dependencies, for instance jdk and maven, configuration to integrate .
* "Getting up and running" is much faster, basically get docker container, source code, and preferred IDE.
* If the developers get the same standard build and runtime environment that will be used with dspace is released into testing, staging, and release, independent of the host OS that they prefer to use.
* Console editors that developers like can be included within the docker image so in this case all development could happen within the docker container.

**Cons:**

* Developing with an IDE can be problematic if the developer wants the IDE to use the build environment contained within the docker container, though some IDE such as NetBeans, Eclipse may have plugins to integrate with the docker build environment (TODO: investigate).
* Developer forced to use more shell development environment.

#### Release centric

**Pros:**
* The development environment developers prefer to use should not be a problem, since all building occurs on the host system side.

**Cons:**

* "Getting up and running" is more complicated, in addition to the docker container, source code, and preferred IDE, the developer will also have to manually install dspace dependencies ( jdk & maven ) for their host OS.
* Developers will have a different build environment from that used when dspace is released into testing, staging, and release.

Common Con:  
Runtime debugging has to be done through tomcat. Some IDE allow integration through

### Working Session

#### Install docker for ubuntu systems

```shell
apt-get install apt-transport-https ca-certificates
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb https://apt.dockerproject.org/repo/ ubuntu-xenial main"
```

**Handy docker scripts**

```shell
git clone glbrimhall@vitae:/data1/vitae/repos/glbrimhall.git
```

**Docker dspac6 6 image built from**

``` shell
git clone glbrimhall@vitae:/data1/vitae/repos/dockerfiles.git
./dbuild-dspace6.sh
```

Tomcat7.dir = /opt/tomcat  
Dspacesrc.dir = /opt/tomcat/dspace-6.1-release  
Dspace.install.dir = /opt/tomcat/dspace

### Using Docker

Handy [FAQ](https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes) on working with docker images/containers:

## Dspace dev videos

[Dspace with Intellij](https://www.youtube.com/watch?v=mrLl1qPsy6I)

## DSpace6-dev docker image

Dspace6 dev image on vitae now, to load it into you're local docker service:  
There are two variations:  
* dspace6-dev: a command line variant for use with either
* command line development within the docker container

First one, command line based (813MB):
```shell
ssh vitae "cat /data1/vitae/repos/dspace6-dev.gz" | gunzip | pv | docker load
```
Second one, ide based (2.94GB):
```shell
ssh vitae "cat /data1/vitae/repos/dspace6-ide.gz" | gunzip | pv | docker load
```

Editing src on on
```shell
ssh vitae "cat /data1/vitae/repos/dspace6-dev.gz" | gunzip | docker load
```
If you have pv util installed, use:
```shell
ssh vitae "cat /data1/vitae/repos/dspace6-dev.gz" | gunzip | pv | docker load
```
File is about 8GB, so pv helps to know when done

Once above is done, create your own container with command:
```shell
docker run --net=host -it --name my-dspace6-dev dspace6:latest /bin/bash
```

If you checkout the src code at `$HOME/dspace6-src`, full command to mount src code into docker image would be:
```shell
docker run --net=host -it -v $HOME/dspace6-src:/opt/tomcat/dspace-6.1-src-release --name my-dspace6-dev dspace6:latest /bin/bash
```

Once above is done, notice you are in `/opt/tomcat dir`. To start dspace, run `bin/startup.sh`. Then in browser http://localhost:8080/jspui.  
Tomcat may not start correctly if you already have something running at 8080

## DSpace jspui development

[JSPUI Configuration and Customization](https://wiki.duraspace.org/display/DSDOC6x/JSPUI+Configuration+and+Customization)
