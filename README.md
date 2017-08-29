# Campus Repository

## Getting Started with the DSpace Docker Image
1. Clone the [Campusepo Repository](http://redmine.library.arizona.edu/projects/dspace/repository) somewhere on your computer  
**Note:** Port 8080 must be open on the host machine    
2. From the root of the repository run,  
```shell
bin/campusrepo-install-dev.pl
```
**Note:** If you have a previous dspace container running, stop it
3. Choose the development option you would like to work with (for the purposes of this documentation we will assume option 2 is chosen)
5. After the script finishes running (and you've provided all the requested input), there is a command that is provided (`docker start my-dspace6-dev; docker exec -it my-dspace6-dev bash`), run that. This will ssh you into the Docker container.
7. Run the build dspace script (can be run from anywhere inside the container):
```shell
build-dspace.sh
```
8. After the script runs you should be able to get to the DSpace JSPUI hime page by going to `http://localhost:8080/jspui` on your host machine  
**Note:** If you are getting an internal error message in JSPUI make sure tomcat is owned by dspace:dspace

## Useful Links

* [DSpace 6.X Documentation](https://wiki.duraspace.org/display/DSDOC6x)
* [DSpace - Advance Customization](https://wiki.duraspace.org/display/DSDOC6x/Advanced+Customisation)
