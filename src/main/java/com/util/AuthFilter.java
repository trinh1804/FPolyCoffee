package com.util;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebFilter({ "/manager/*", "/employee/*" })
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Khởi tạo filter
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String uri = req.getRequestURI();

        // Kiểm tra đã đăng nhập chưa
        if (!AuthUtil.isAuthenticated(req)) {
            // Chưa đăng nhập → lưu URL muốn truy cập rồi chuyển về trang đăng nhập
            req.getSession().setAttribute("REDIRECT_URL", uri);
            res.sendRedirect(req.getContextPath() + "/dang-nhap");
            return; // ← ĐÃ SỬA: thêm return để không gọi chain
        }

        // Kiểm tra quyền truy cập vào /manager/*
        if (uri.contains("/manager") && !AuthUtil.isManager(req)) {
            // Đã đăng nhập nhưng không có quyền quản lý
            res.sendRedirect(req.getContextPath() + "/trang-chu");
            return;
        }

        // Hợp lệ → tiếp tục xử lý
        chain.doFilter(req, res);
    }

    @Override
    public void destroy() {
        // Hủy filter
    }
}