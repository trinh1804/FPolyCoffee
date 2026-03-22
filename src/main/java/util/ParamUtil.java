package util;

import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

public class ParamUtil {
    public static String getString(HttpServletRequest request, String name) {
        try {
            return request.getParameter(name);
        } catch (Exception e) {
            return null;
        }
    }

    public static int getInt(HttpServletRequest request, String name) {
        try {
            return Integer.parseInt(request.getParameter(name));
        } catch (Exception e) {
            return 0;
        }
    }

    public static Date getDate(HttpServletRequest request, String name, String pattern) {
        try {
            String value = request.getParameter(name);
            return new SimpleDateFormat(pattern).parse(value);
        } catch (Exception e) {
            return null;
        }
    }
}
