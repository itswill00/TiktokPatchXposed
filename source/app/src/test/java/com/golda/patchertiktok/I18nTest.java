package com.golda.patchertiktok;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.junit.Test;

public class I18nTest {
    @Test
    public void everyTableHasEveryString() {
        for (Map.Entry<String, String[]> table : I18n.tables().entrySet()) {
            assertEquals(table.getKey(), I18n.S.values().length, table.getValue().length);
            for (String value : table.getValue()) assertFalse(table.getKey(), value.trim().isEmpty());
        }
    }

    private static final Pattern SPECIFIER = Pattern.compile("%(?:\\d+\\$)?[-+#0 ]*\\d*(?:\\.\\d+)?[a-zA-Z%]");

    private static List<String> specifiers(String value) {
        List<String> found = new ArrayList<>();
        Matcher matcher = SPECIFIER.matcher(value);
        while (matcher.find()) found.add(matcher.group());
        assertFalse("Unescaped percent in: " + value, matcher.replaceAll("").contains("%"));
        Collections.sort(found);
        return found;
    }

    @Test
    public void everyLanguageKeepsTheFormatSpecifiers() {
        String[] english = I18n.tables().get("en");
        for (Map.Entry<String, String[]> table : I18n.tables().entrySet()) {
            assertEquals(table.getKey(), english.length, table.getValue().length);
            for (int i = 0; i < english.length; i++) {
                assertEquals(table.getKey() + " #" + i, specifiers(english[i]), specifiers(table.getValue()[i]));
            }
        }
    }

    @Test
    public void arabicHasItsOwnTable() {
        I18n.use(new Locale("ar"));
        assertEquals("حظر الإعلانات", I18n.get(I18n.S.ADS));
        I18n.use(Locale.ENGLISH);
    }

    @Test
    public void unknownLanguageFallsBackToEnglish() {
        I18n.use(new Locale("ja"));
        assertEquals("Block ads", I18n.get(I18n.S.ADS));
        I18n.use(new Locale("kk"));
        assertEquals("Блокировать рекламу", I18n.get(I18n.S.ADS));
        I18n.use(new Locale("in"));
        assertEquals("Blokir iklan", I18n.get(I18n.S.ADS));
        I18n.use(Locale.ENGLISH);
    }
}
