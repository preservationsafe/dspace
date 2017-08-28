# Campus Repository

## Getting Started with the DSpace Docker Image
1. Clone the [Campusepo Repository](http://redmine.library.arizona.edu/projects/dspace/repository) somewhere on your computer  
**Note:** Port 8080 must be open on the host machine    
2. From the root of the repository run,  
```shell
bin/campusrepo-install-dev.pl
```
3. Choose the development option you would like to work with (for the purposes of this documentation we will assume option 2 is chosen)
5. After the script finishes running (and you've provided all the requested input), there is a command that is provided (`docker start my-dspace6-dev; docker exec -it my-dspace6-dev bash`), run that. This will ssh you into the Docker container.
6. cd into the home directory by just runing `cd`
7. Your current directory should be `/opt/tomcat/dspace`, from here run  
```shell
bin/build-dspace.sh
```
8. After the script runs you should be able to get to the DSpace JSPUI hime page by going to `http://localhost:8080/jspui` on your host machine
