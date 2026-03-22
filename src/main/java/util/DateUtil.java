package util;

import java.text.SimpleDateFormat;
import java.util.Date;

public class DateUtil {
    public static Date toDate(String value, String pattern) {
        try {
            if (value == null || value.isEmpty())
                return null;
            return new SimpleDateFormat(pattern).parse(value);
        } catch (Exception e) {
            return null;
        }
    }

    public static String toString(Date date, String pattern) {
        if (date == null)
            return "";
        return new SimpleDateFormat(pattern).format(date);
    }
}
