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
 * Unit Tests for nothing in particular
 * See dspace-api/src/test/java/org.dspace/AbstractUnitTest for more info.
 *
 * @author turmanator
 */
public class TestingTest{
    /** log4j category */
    private static final Logger log = Logger.getLogger(TestingTest.class);

    /**
     * Test the testing of test
     */
    @Test
    public void testTesting() {
        try {
            /*fail("ALERT: this a test of a failing unit test");*/
            throw new IllegalStateException("This test tests a test. Wait, huh?");
        } catch (IllegalStateException e) {
            assertNotNull(e.getMessage());
        }
    }

    /**
     * Test the number of test
     */
    @Test
    public void testNumber() {
        assertEquals(4, 4);
    }

    @Test
    public void testSelenium() throws MalformedURLException {
        RemoteWebDriver driver = new RemoteWebDriver(
                new URL("http://localhost:4444/wd/hub"),
                DesiredCapabilities.firefox());
        driver.get("https://google.com");
        String title = driver.getTitle();
        String seekTitle = "Google";
        assertEquals(title, seekTitle);
        // close the browser
        driver.quit();
    }
}
