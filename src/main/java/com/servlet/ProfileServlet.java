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

@WebServlet("/thong-tin-ca-nhan")
public class ProfileServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!AuthUtil.isAuthenticated(req)) {
            resp.sendRedirect(req.getContextPath() + "/dang-nhap");
            return;
        }
        req.getRequestDispatcher("/views/auth/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!AuthUtil.isAuthenticated(req)) {
            resp.sendRedirect(req.getContextPath() + "/dang-nhap");
            return;
        }

        User currentUser = AuthUtil.getUser(req);
        String fullName = ParamUtil.getString(req, "fullName");
        String phone    = ParamUtil.getString(req, "phone");
        boolean hasError = false;

        if (fullName == null || fullName.trim().isEmpty()) {
            req.setAttribute("fullNameError", "Họ tên không được để trống!");
            hasError = true;
        }

        if (phone == null || phone.trim().isEmpty()) {
            req.setAttribute("phoneError", "Số điện thoại không được để trống!");
            hasError = true;
        } else {
            User existPhone = userDAO.findByPhone(phone);
            if (existPhone != null && !existPhone.getId().equals(currentUser.getId())) {
                req.setAttribute("phoneError", "Số điện thoại đã tồn tại!");
                hasError = true;
            }
        }

        if (hasError) {
            req.getRequestDispatcher("/views/auth/profile.jsp").forward(req, resp);
            return;
        }

        currentUser.setFullName(fullName);
        currentUser.setPhone(phone);

        int result = userDAO.updateProfile(currentUser);
        if (result > 0) {
            // Cập nhật session
            AuthUtil.setUser(req, currentUser);
            req.setAttribute("message", "Cập nhật thông tin thành công!");
        } else {
            req.setAttribute("error", "Cập nhật thất bại, vui lòng thử lại!");
        }

        req.getRequestDispatcher("/views/auth/profile.jsp").forward(req, resp);
    }
}
