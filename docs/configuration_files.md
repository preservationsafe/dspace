# Configuration Files

### Local Configuration
All the properties that might change from environment to environment are set in build.properties (copied from build.properties.EXAMPLE and not versioned). Each `build_` ant target (in `campusrepo/build.xml`) will copy `local.cfg.EXAMPLE` to `local.cfg` and replace the tokens in `local.cfg.EXAMPLE` with the properties set in `build.properties` (tokens begin and end with @ symbols). If additional properties need to be added to `build.properties` take the following steps. In this example we'll say that we want to set is the `example.property` property in `local.cfg`.

* Set the value of `example.property` to @EXAMPLE_PROPERTY@ in `local.cfg.EXAMPLE`. The constant inside the @ symbols doesn't particularly matter, although the current properties are following the convention of all letters being uppercase and changing the period to an underscore. 
    ```
    example.property = @EXAMPLE_PROPERTY@
    ```

* In the `copy_local_config` target in `campusrepo/build.xml` add a filter to the filter set for `example.property`
    ``` xml            
    <filterset>
        <filter token="DSPACE_DIR" value="${dspace.dir}"/>
        <filter token="DB_URL" value="${db.url}"/>
        <filter token="DB_USER" value="${db.username}"/>
        <filter token="DB_PASSWORD" value="${db.password}"/>
        <filter token="ASSETSTORE_DIR" value="${assetstore.dir}"/>
        <!-- The additional filter for example.property -->
        <filter token="@EXAMPLE_PROPERTY@" value="${example.property}"/> 
    ```

* Then set the value in `build.properties`
```
example.property = some value
```

* Now when you run any of the `build_` ant targets, `local.cfg.EXAMPLE` will be copied to `local.cfg` with the value of `example.property` being set to "some value"