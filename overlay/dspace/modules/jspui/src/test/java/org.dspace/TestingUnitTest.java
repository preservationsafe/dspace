package org.dspace;

import org.junit.Test;
import static org.junit.Assert.*;

import org.apache.log4j.Logger;

/**
 * Unit Tests for nothing in particular
 * See dspace-api/src/test/java/org.dspace/AbstractUnitTest for more info.
 *
 * @author turmanator
 */
public class TestingUnitTest{
    /** log4j category */
    private static final Logger log = Logger.getLogger(TestingUnitTest.class);

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
}
