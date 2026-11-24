package com.golda.patchertiktok;

import org.junit.Test;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

public class ContentFilterTest {
    @Test public void hiddenByRulesUsesTikTokVideoDuration() {
        FilterRules rules = FilterRules.parse("", "", 0, 0, 10, 20, null);
        assertTrue(ContentFilter.hiddenByRules(new FakeAweme(5_000), rules));
        assertFalse(ContentFilter.hiddenByRules(new FakeAweme(15_000), rules));
        assertTrue(ContentFilter.hiddenByRules(new FakeAweme(21_000), rules));
        assertFalse(ContentFilter.hiddenByRules(new FakeAweme(-1), rules));
    }

    /** Only the getters ContentFilter.hiddenByRules consults. */
    public static final class FakeAweme {
        private final long duration;

        FakeAweme(long duration) { this.duration = duration; }

        public long getDuration() { return duration; }
        public Object getDesc() { return ""; }
        public Object getAuthor() { return null; }
        public Object getStatistics() { return null; }
        public Object getTextExtra() { return null; }
    }
}
