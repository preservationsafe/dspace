
# Campusrepo DSpace
The University of Arizona Library's Customized DSpace Installation for the UA Campus Repository. This project is built around the DSpace platform ([DSpace github](https://github.com/DSpace/DSpace)).

## Getting Started 

### Prerequisites
* Linux/Unix Operating System
* Java JDK 8 
* Apache Maven 3.0.5 or above
* Apache Ant 1.8 or later
* PostgreSQL 9.6
* Tomcat 8

### Installing
* Setup the database. To install a copy of the database from repository-tst check "Database Migrations" below. Otherwise, for a vanilla install: 
  * Create the database

  ```
  createdb --username=[Postgres-superuser] --owner=[db-user] --encoding=UNICODE [db-name]
  ```
  * Enable the pgcrypto extension
  ```
  psql --username=[Postgres-superuser] [db-name] -c "CREATE EXTENSION pgcrypto;"  
  ```

* Copy `build.properties.EXAMPLE` to `build.properties` and update the following properties
    * **dspace.dir**: This is the DSpace installation directory (must be an absolute path)
    * **db.url**: The url of your PostgreSQL database, you may need to update the name of the database in the url
    * **db.username**: Username of the owner of the PostgreSQL database
    * **db.password**: Password of the owner of the PostgreSQL database
    * **assetstore.dir**: The directory of your assetstore directory
    
    **Note**: These properties correspond to properties in local.cfg.EXAMPLE. All the `build_*` targets will copy 
    `dspace/config/local.cfg.EXAMPLE` to `dspace/config/local.cfg` and place the value of those properties into 
    `local.cfg` using a filter. This eliminates the need to set up `local.cfg` manually. 
    There are more properties available in build.properties.EXAMPLE. Feel free to leave any properties out where you 
    want to accept the defaults from `dspace.cfg`.
    
* Change the owner (user and group) of `dspace-install` to who ever owns your tomcat directory
* Run
```
ant build_init
``` 
* Ensure these xml files have the correct **dspace.dir** defined in them:
  * {tomcatLocation}/conf/Catalina/localhost/jspui.xml
  * {tomcatLocation}/conf/Catalina/localhost/solr.xml
  * {mavenLocation}/conf/settings.xml

* Start tomcat (if already running you may need to restart)
  * To shutdown, run {tomcatLocation}/bin/shutdown.sh
  * To startup OUTSIDE IntelliJ (more info how to start up inside IntelliJ below...), run either {tomcatLocation}/bin/startup.sh or campusrepo/bin/debug-tomcat.sh 
  * Can check the {tomcatLocation}/logs/Catalina.out file for more details on if it started or what error occurred.
  * If tomcat shows an error about the **dspace.dir** property being unknown or it matches an incorrect location (such as the no long valid /opt/tomcat/dspace...), please check the .xml files listed above to make sure the location is correctly defined.

## How to work on this project

Every file (other than configuration files) that is worked on should be placed in the `dspace/modules` directory. Where you place them within that directory should match the file structure of the file you are customizing. 
  * For example, if you wanted to customize a .jsp file from the dspace-jspui src foldr `dspace-jspui/src/main/webapp/layout/header-default.jsp`, then you would copy that file to `dspace/modules/jspui/src/main/webapp/layout/header-default.jsp`. 
  * For example, if you wanted to customize a .java file from the dspace-jspui src folder `dspace-jspui/src/main/java/org/dspace/app/webui/submit/step/JSPDescribeStep.java` then you would copy that file to `dspace/modules/jspui/src/main/java/org/dspace/app/webui/submit/step/JSPDescribeStep.java`. 
  * For example, if you wanted to customize a .java file from the dspace-api src folder `dspace-api/src/main/java/org/dspace/submit/step/SelectCollectionStep.java` then you would copy that file to `dspace/modules/additions/src/main/java/org/dspace/submit/step/SelectCollectionStep.java`.
For entirely custom .jsp or .java files place in the location you would intuitively look for them in (ie, a new submission step you would place in the location of other submission step files) and they will likely need to be referenced in a configuration file depending on the case (more info TBD as more knowledge is gained). The Maven War plug-in will configure your build so that the file in the `dspace/modules` directory will be used as the default. This includes any JSP files or any DSpace api related files. Configuration files (e.g. input-forms.xml) should be altered in placed and versioned (essentially forked). Use one of the several ant `build_*` targets, found in `build.xml` to deploy locally (additional documentation can be found in that file).  

## IDE Suggestions

For use with IntelliJ Ultimate, follow these steps:
* Open IntelliJ and select 'Import Project'
* Navigate to the campusrepo location on your machine
* Select 'Import project from external model' -> 'Maven'
* Finish setup wizard and wait for IntelliJ to finish setiing things up, ie nothing is running in the bottom right corner and messages tab shows no more incoming info
* Open the 'Ant Build' view on the right and ensure campusrepo is shown with at least 'build_clean', 'build_full', 'build_init', 'build_quick', and 'get_src_files' targets listed.
  * If not, click the '+' and navigate to the build.xml under the root dir of campusrepo is selected.
* Run the 'build_init' ant target.
* If want to develop with src code, run the 'get_src_files' target and they should be shown in the project tree once finished.
* Setup the tomcat configuration:
  * Open 'Edit Configurations' and hit the '+' sign and navigate to Tomcat -> local
  * Title it, set the Application server to the tomcat install dir, make sure JRE is set to the default
  * Make sure under Open Browser section, 'http://localhost:8080/jspui/' is shown
  * '-' on the 'build' listed in the before launch section
  * Navigate to the Deployment tab and click '+' to add two artifacts:
    * jspui:war exploded with application context of /jspui
    * solr:war exploded with application context of /solr
  * Save and run (best to use debug mode)
    * If tomcat shows an error about the **dspace.dir** property being unknown or it matches an incorrect location (such as the no longer valid /opt/tomcat/dspace...), please check the .xml files listed above to make sure the location is correctly defined. If those are defined correctly and still getting this error, verify tomcat will start OUTSIDE IntelliJ successfully, shut it down, then run 'build_clean' and retry.

## Getting the source files

For this project we are using the the dspace-release version of dspace. There is also a dspace-src-release version of dspace (you can see all the release version on the [DSpace github release page](https://github.com/DSpace/DSpace/releases)). You can run the ant target `get_dspace_src` to grab those files and include them in your local copy of the project. Maven will recognize that you are including those files in the project and will opt to use those instead of the compiled jar files in your local Maven repository. This will allow you to explore and text DSpace source code, though you don't need them just to install DSpace locally and alter the files using the DSpace `modules` directory. 

## Database Migrations

The script, `bin/setup-local-db.sh`, can be used to create the database and import a copy of the database from repository-tst. Addtional documentation can be found in the script. 

## Current Environments
* **Production (Hosted by Atmire):** [arizona.openrepository.com](http://arizona.openrepository.com/arizona/)
* **Test:** [repository-tst.library.arizona.edu](http://repository-tst.library.arizona.edu/jspui/)

## Additional Resources
* [DSpace 6.X Documentation](https://wiki.duraspace.org/display/DSDOC6x)	
* [DSpace - Advance Customization](https://wiki.duraspace.org/display/DSDOC6x/Advanced+Customisation)
* [DSpace 6.x Install Instructions](https://wiki.duraspace.org/display/DSDOC6x/Installing+DSpace) (May be helpful with installing the prerequisites)
