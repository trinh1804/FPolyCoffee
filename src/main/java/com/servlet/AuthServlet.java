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

@WebServlet("/dang-nhap")
public class AuthServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (AuthUtil.isAuthenticated(req)) {
            resp.sendRedirect(req.getContextPath() + "/trang-chu");
            return;
        }
        req.getRequestDispatcher("/views/auth/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = ParamUtil.getString(req, "email");
        String password = ParamUtil.getString(req, "password");

        User user = userDAO.findByEmail(email);

        if (user == null) {
            req.setAttribute("message", "Email không tồn tại!");
        } else if (!user.isActive()) {
            req.setAttribute("message", "Tài khoản đã bị khóa!");
        } else if (!user.getPassword().equals(password)) {
            req.setAttribute("message", "Mật khẩu không đúng!");
        } else {
            AuthUtil.setUser(req, user);
            String redirect = req.getContextPath() + "/trang-chu";
            resp.sendRedirect(redirect);
            return;
        }

        req.getRequestDispatcher("/views/auth/login.jsp").forward(req, resp);
    }
}