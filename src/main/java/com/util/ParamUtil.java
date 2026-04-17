package com.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

public class ParamUtil {

    public static String getString(HttpServletRequest request, String name) {
        try {
            String value = request.getParameter(name);
            return value != null ? value.trim() : null;
        } catch (Exception e) {
            return null;
        }
    }

    public static String getString(HttpServletRequest request, String name, String defaultValue) {
        String value = getString(request, name);
        return value != null ? value : defaultValue;
    }

    public static int getInt(HttpServletRequest request, String name) {
        try {
            String value = request.getParameter(name);
            if (value == null || value.trim().isEmpty())
                return 0;
            return Integer.parseInt(value.trim());
        } catch (Exception e) {
            return 0;
        }
    }

    /**
     * BUG FIX: phiên bản cũ luôn gọi getInt(req, name) và bọc trong try-catch,
     * nhưng getInt không throw — defaultValue không bao giờ được trả về.
     * Fix: kiểm tra tham số null/rỗng trước, rồi mới parse.
     */
    public static int getInt(HttpServletRequest request, String name, int defaultValue) {
        try {
            String value = request.getParameter(name);
            if (value == null || value.trim().isEmpty())
                return defaultValue;        // ← trả về defaultValue nếu không có param
            return Integer.parseInt(value.trim());
        } catch (Exception e) {
            return defaultValue;
        }
    }

    public static Date getDate(HttpServletRequest request, String name, String pattern) {
        try {
            String value = request.getParameter(name);
            if (value == null || value.trim().isEmpty())
                return null;
            return new SimpleDateFormat(pattern).parse(value.trim());
        } catch (ParseException e) {
            e.printStackTrace();
            return null;
        } catch (Exception e) {
            return null;
        }
    }

    public static boolean getBoolean(HttpServletRequest request, String name) {
        try {
            String value = request.getParameter(name);
            if (value == null)
                return false;
            return "on".equalsIgnoreCase(value) || "true".equalsIgnoreCase(value) || "1".equals(value);
        } catch (Exception e) {
            return false;
        }
    }

    public static double getDouble(HttpServletRequest request, String name, double defaultValue) {
        try {
            String value = request.getParameter(name);
            if (value == null || value.trim().isEmpty())
                return defaultValue;
            return Double.parseDouble(value.trim());
        } catch (Exception e) {
            return defaultValue;
        }
    }
}
