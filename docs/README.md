### Getting Up and Running
1. Install tomcat
2. Clone the repository
3. Create a dspace install directory 
4. Copy `local.cfg.campusrepo.EXAMPLE` to `local.cfg`
5. Change the properties in `local.cfg` to work with your enviroment  
**Note:** Change the `dspace.dir` property to wherever you placed the dspace install directory. Change the `assetstore.dir` to wherever you have the assetstore mounted
6. Copy `build.properties.EXAMPLE` to `build.properties` and change `dspace_install.dir` value to the path to where you placed the dspace install directory
7. Run `ant fresh_build`