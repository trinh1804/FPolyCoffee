package util;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebFilter({ "/manager/*", "/employee/*" })
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String uri = req.getRequestURI();

        if (!AuthUtil.isAuthenticated(req)) {
            // Chưa đăng nhập → lưu URL muốn truy cập rồi chuyển về trang đăng nhập
            req.getSession().setAttribute("REDIRECT_URL", uri);
            res.sendRedirect(req.getContextPath() + "/dang-nhap");
            return; // ← BUG CŨ: không có return + gọi chain 2 lần
        }

        if (uri.contains("/manager") && !AuthUtil.isManager(req)) {
            // Đã đăng nhập nhưng không có quyền quản lý
            req.getSession().setAttribute("REDIRECT_URL", uri);
            res.sendRedirect(req.getContextPath() + "/dang-nhap");
            return;
        }

        // Hợp lệ → tiếp tục xử lý
        chain.doFilter(req, res);
    }
}
