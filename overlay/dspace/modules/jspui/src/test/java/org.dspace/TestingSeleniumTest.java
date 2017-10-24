package org.dspace;

import static java.lang.System.out;

import org.junit.Test;
import org.junit.Before;
import org.junit.After;
import static org.junit.Assert.*;

import org.openqa.selenium.*;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.remote.RemoteWebDriver;

import java.net.URL;
import java.net.InetAddress;
import java.net.MalformedURLException;
import java.net.UnknownHostException;

import org.apache.log4j.Logger;

/**
 * Trying out our hand on some automation.
 * See also https://github.com/SeleniumHQ/docker-selenium
 *
 * @author turmanator
 */
public class TestingSeleniumTest{
    /** log4j category */
    private static final Logger log = Logger.getLogger(TestingSeleniumTest.class);

    private RemoteWebDriver driver;
    private String urlDspaceJspui;

    @Before
    public void createDriver() throws MalformedURLException, UnknownHostException {

        System.out.println("@Before - get local host ip and name.");
        InetAddress addr = InetAddress.getLocalHost();
        String localHostIp = addr.getHostAddress();
        String localHostName = addr.getHostName();
        String urlSelenium;

        if ( localHostName.equals( "build-dspace6-dev" ) ) {
           // Values to run in a docker isolated network
           urlDspaceJspui = "http://" + localHostIp + ":8080/jspui";
           urlSelenium = "http://selenium:4444/wd/hub";
        }
        else {
           // If tests are not running on the build server, assume localhost access
           urlDspaceJspui = "http://localhost:8080/jspui";
           urlSelenium = "http://localhost:4444/wd/hub";
        }

        System.out.println("@Before - create our driver.");
        driver = new RemoteWebDriver(
                // The URL port is defined on Docker startup of Selenium
                new URL( urlSelenium ),
                // Use firefox, since preferred Docker image is selenium/standalone-firefox:2.53.0
                DesiredCapabilities.firefox());
    }

    @After
    public void closeBrowser() {
        System.out.println("@After - close our browser down.");
        driver.quit();
    }

    @Test
    public void testGoogle() throws MalformedURLException {
        driver.get("https://google.com");
        String title = driver.getTitle();
        String seekTitle = "Google";
        assertEquals(seekTitle, title);

    }
    @Test
    public void testDspaceHomepage() throws MalformedURLException, UnknownHostException {
        driver.get( urlDspaceJspui );
        String title = driver.getTitle();
        String seekTitle = "University of Arizona Library TESS: Home";
        assertEquals(seekTitle, title);
    }
}
