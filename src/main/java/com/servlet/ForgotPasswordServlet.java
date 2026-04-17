package com.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dao.UserDAO;
import com.entity.User;
import com.util.Mailer;
import com.util.ParamUtil;

@WebServlet("/quen-mat-khau")
public class ForgotPasswordServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = ParamUtil.getString(req, "email");

        // Check email tồn tại
        User user = userDAO.findByEmailAny(email);

        if (user == null) {
            req.setAttribute("error", "Email không tồn tại trong hệ thống!");
            req.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(req, resp);
            return;
        }

        if (!user.isActive()) {
            req.setAttribute("error", "Tài khoản đã bị khóa, vui lòng liên hệ quản trị viên!");
            req.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(req, resp);
            return;
        }

        // Random mật khẩu mới (6 ký tự)
        String newPassword = generateRandomPassword(6);

        // Cập nhật vào database
        int result = userDAO.resetPassword(user.getId(), newPassword);

        if (result > 0) {
            // Gửi email
            String subject = "[FPolyCoffee] Mật khẩu mới của bạn";
            String body = buildEmailBody(user.getFullName(), newPassword);

            int mailResult = Mailer.send("vythaianh2021@gmail.com", user.getEmail(), subject, body);

            if (mailResult > 0) {
                req.setAttribute("message",
                        "Mật khẩu mới đã được gửi đến email " + user.getEmail() + ". Vui lòng kiểm tra hộp thư!");
            } else {
                req.setAttribute("error", "Đã cập nhật mật khẩu nhưng gửi email thất bại! Vui lòng thử lại sau.");
            }
        } else {
            req.setAttribute("error", "Cập nhật mật khẩu thất bại! Vui lòng thử lại sau.");
        }

        req.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(req, resp);
    }

    /**
     * Tạo mật khẩu ngẫu nhiên
     */
    private String generateRandomPassword(int length) {
        String chars = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjklmnpqrstuvwxyz23456789";
        StringBuilder password = new StringBuilder();
        for (int i = 0; i < length; i++) {
            int index = (int) (Math.random() * chars.length());
            password.append(chars.charAt(index));
        }
        return password.toString();
    }

    /**
     * Tạo nội dung email
     */
    private String buildEmailBody(String fullName, String newPassword) {
        return "<html><body style='font-family: Arial, sans-serif;'>" +
                "<div style='max-width: 600px; margin: 0 auto; padding: 20px;'>" +
                "<h2 style='color: #007bff;'>Xin chào " + fullName + ",</h2>" +
                "<p>Hệ thống FPolyCoffee đã nhận được yêu cầu cấp lại mật khẩu từ bạn.</p>" +
                "<p><strong>Mật khẩu mới của bạn là:</strong></p>" +
                "<div style='background-color: #f0f0f0; padding: 15px; text-align: center; font-size: 24px; font-weight: bold; letter-spacing: 2px; margin: 20px 0;'>"
                +
                newPassword +
                "</div>" +
                "<p>Vui lòng đăng nhập và đổi mật khẩu ngay để bảo mật tài khoản.</p>" +
                "<hr style='margin: 20px 0;'>" +
                "<p><i>Trân trọng,</i><br><strong>Đội ngũ FPolyCoffee</strong></p>" +
                "</div></body></html>";
    }
}