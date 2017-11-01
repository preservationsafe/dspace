### Getting Up and Running
1. Install tomcat
2. Clone the repository
3. Copy `local.cfg.campusrepo.EXAMPLE` to `local.cfg`
4. Change the properties in `local.cfg` to work with your enviroment
5. Copy `build.properties.EXAMPLE` to `build.properties` and change `dspace_install.dir` value to the path to where you want the dspace install directory
6. Run `ant fresh_build`