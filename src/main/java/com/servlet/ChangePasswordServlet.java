package com.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dao.UserDAO;
import com.entity.User;
import com.util.AuthUtil;
import com.util.ParamUtil;

@WebServlet("/doi-mat-khau")
public class ChangePasswordServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!AuthUtil.isAuthenticated(req)) {
            resp.sendRedirect(req.getContextPath() + "/dang-nhap");
            return;
        }
        req.getRequestDispatcher("/views/auth/change-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!AuthUtil.isAuthenticated(req)) {
            resp.sendRedirect(req.getContextPath() + "/dang-nhap");
            return;
        }

        User currentUser = AuthUtil.getUser(req);
        String oldPassword  = ParamUtil.getString(req, "oldPassword");
        String newPassword  = ParamUtil.getString(req, "newPassword");
        String confirmPassword = ParamUtil.getString(req, "confirmPassword");

        if (oldPassword == null || oldPassword.isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập mật khẩu cũ!");
            forward(req, resp);
            return;
        }

        if (!currentUser.getPassword().equals(oldPassword)) {
            req.setAttribute("error", "Mật khẩu cũ không đúng!");
            forward(req, resp);
            return;
        }

        if (newPassword == null || newPassword.length() < 6) {
            req.setAttribute("error", "Mật khẩu mới phải có ít nhất 6 ký tự!");
            forward(req, resp);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            req.setAttribute("error", "Xác nhận mật khẩu không khớp!");
            forward(req, resp);
            return;
        }

        int result = userDAO.updatePassword(currentUser.getId(), newPassword);
        if (result > 0) {
            // Cập nhật lại session để không bị lỗi đăng nhập tiếp theo
            currentUser.setPassword(newPassword);
            AuthUtil.setUser(req, currentUser);
            req.setAttribute("message", "Đổi mật khẩu thành công!");
        } else {
            req.setAttribute("error", "Đổi mật khẩu thất bại, vui lòng thử lại!");
        }

        forward(req, resp);
    }

    private void forward(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/views/auth/change-password.jsp").forward(req, resp);
    }
}
