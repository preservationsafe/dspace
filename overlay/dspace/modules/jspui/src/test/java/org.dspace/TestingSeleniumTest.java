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
import java.net.MalformedURLException;

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

    @Before
    public void createDriver() throws MalformedURLException {
        System.out.println("@Before - create our driver.");
        driver = new RemoteWebDriver(
                // The URL port is defined on Docker startup of Selenium
                new URL("http://localhost:4444/wd/hub"),
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
        assertEquals(title, seekTitle);

    }
}
