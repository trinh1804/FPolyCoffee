package com.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.entity.User;

public class AuthUtil {
    public static final String SESSION_USER = "user";
    public static final int ROLE_MANAGER = 1;
    public static final int ROLE_STAFF = 2;

    /** Lưu user vào session */
    public static void setUser(HttpServletRequest request, User user) {
        request.getSession().setAttribute(SESSION_USER, user);
    }

    /** Lấy user từ session */
    public static User getUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null)
            return null;
        return (User) session.getAttribute(SESSION_USER);
    }

    /** Đã đăng nhập chưa? */
    public static boolean isAuthenticated(HttpServletRequest request) {
        return getUser(request) != null;
    }

    /** Là quản lý không? (roleId == 1) */
    public static boolean isManager(HttpServletRequest request) {
        User u = getUser(request);
        return u != null && u.getRoleId() != null && u.getRoleId() == ROLE_MANAGER;
    }

    /** Là nhân viên không? (roleId == 2) */
    public static boolean isStaff(HttpServletRequest request) {
        User u = getUser(request);
        return u != null && u.getRoleId() != null && u.getRoleId() == ROLE_STAFF;
    }

    /** Xóa session đăng nhập */
    public static void clear(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.removeAttribute(SESSION_USER);
        }
    }
}