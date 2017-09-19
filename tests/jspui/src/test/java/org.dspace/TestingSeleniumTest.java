package org.dspace;

import org.junit.Test;
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

    /**
     * Test automation system
     */
    @Test
    public void testSelenium() throws MalformedURLException {
        RemoteWebDriver driver = new RemoteWebDriver(
                // The URL port is defined on Docker startup of Selenium
                new URL("http://localhost:4444/wd/hub"),
                // Use firefox, since preferred Docker image is selenium/standalone-firefox:2.53.0
                DesiredCapabilities.firefox());
        driver.get("https://google.com");
        String title = driver.getTitle();
        String seekTitle = "Google";
        assertEquals(title, seekTitle);
        // close the browser
        driver.quit();
    }
}
