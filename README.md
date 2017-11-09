
# Campusrepo DSpace
The University of Arizona Library's Customized DSpace Installation for the UA Campus Repository. This project is built around the DSpace platform ([DSpace github](https://github.com/DSpace/DSpace)).

## Getting Started 

### Perquisites
* Linux/Unix Operating System
* Java JDK 8 
* Apache Maven 3.0.5 or above
* Apache Ant 1.8 or later
* PostgreSQL 9.6
* Tomcat 8

### Installing
* Create the database
  
  If you are going to migreate the database from repository-tst dspacedba will need to be the owner
```
createdb --username=[Postgres superuser] --owner=dspacedba --encoding=UNICODE [db name]
```
* Enable the pgcrypto extension
```
psql --username=[Postgres superuser] [db name] -c "CREATE EXTENSION pgcrypto;"  
```

* Update `local.cfg` for your enviroment. Some properties to pay attention to:
    * **dspace.dir**: This is the DSpace installation directory (must be an absolute path)
    * **dspace.baseUrl**: DSpace host url
    * **db.url**: The url of your PostgreSQL database, you may need to update the name of the database in the url
    * **db.username**: Username of the owner of the PostgreSQL database
    * **db.password**: Password of the owner of the PostgreSQL database
* Copy `build.properties.EXAMPLE` to `build.properties` and update the **dspace_install.dir** to your DSpace installation (same as **dspace.dir** in `local.cfg`, and must also be an absolute path)
* Change the owner (user and group) of `dspace-install` to who ever owns your tomcat directory
* Run
```
ant build_init
``` 
* Start tomcat (if already running you may need to restart)

## How to work on this project

Every file (other than configuration files) that is worked on should be placed in the `dspace/modules` directory. Where you place them within that directory should match the file structure of the web app you are customizing. For example, if you wanted to customize `dspace-jspui/src/main/webapp/layout/header-default.jsp`, then you would copy that file to `dspace/modules/jspui/src/main/webapp/layout/header-default.jsp`. The Maven War plug-in will configure your build so that the file in the `dspace/modules` directory will be used as the default. This includes any JSP files or any DSpace api related files. Configuration files (e.g. input-forms.xml) should be altered in placed and versioned (essentially forked). Use one of the several ant `build_*` targets, found in `build.xml` to deploy locally (additional documentation can be found in that file).  

## Getting the source files

For this project we are using the the dspace-release version of dspace. There is also a dspace-src-release version of dspace (you can see all the release version on the [DSpace github release page](https://github.com/DSpace/DSpace/releases)). You can run the ant target `get_dspace_src` to grab those files and include them in your local copy of the project. Maven will recognize that you are including those files in the project and will opt to use those instead of the compiled jar files in your local Maven repository. This will allow you to explore and text DSpace source code, though you don't need them just to install DSpace locally and alter the files using the DSpace `modules` directory. 

## Current Environments
* **Production (Hosted by Atmire):** [arizona.openrepository.com](http://arizona.openrepository.com/arizona/)
* **Test:** [repository-tst.library.arizona.edu](http://repository-tst.library.arizona.edu/jspui/)

## Additional Resources
* [DSpace 6.X Documentation](https://wiki.duraspace.org/display/DSDOC6x)	
* [DSpace - Advance Customization](https://wiki.duraspace.org/display/DSDOC6x/Advanced+Customisation)
* [DSpace 6.x Install Instructions](https://wiki.duraspace.org/display/DSDOC6x/Installing+DSpace) (May be helpful with installing the prerequisites)