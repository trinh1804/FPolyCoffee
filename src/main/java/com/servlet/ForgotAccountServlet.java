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

@WebServlet("/quen-tai-khoan")
public class ForgotAccountServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/views/auth/forgot-account.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String phone = ParamUtil.getString(req, "phone");

        if (phone == null || phone.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập số điện thoại!");
            req.getRequestDispatcher("/views/auth/forgot-account.jsp").forward(req, resp);
            return;
        }

        User user = userDAO.findByPhone(phone.trim());

        if (user == null) {
            req.setAttribute("error", "Không tìm thấy tài khoản với số điện thoại này!");
            req.getRequestDispatcher("/views/auth/forgot-account.jsp").forward(req, resp);
            return;
        }

        if (!user.isActive()) {
            req.setAttribute("error", "Tài khoản đã bị khóa, vui lòng liên hệ quản trị viên!");
            req.getRequestDispatcher("/views/auth/forgot-account.jsp").forward(req, resp);
            return;
        }

        // Gửi email thông tin tài khoản
        String subject = "[FPolyCoffee] Thông tin tài khoản của bạn";
        String body    = buildEmailBody(user);
        int mailResult = Mailer.send(user.getEmail(), subject, body);

        if (mailResult > 0) {
            req.setAttribute("message",
                "Thông tin tài khoản đã được gửi đến email " + maskEmail(user.getEmail()) + "!");
        } else {
            // Fallback nếu gửi mail thất bại — vẫn hiển thị email đã che
            req.setAttribute("message",
                "Tài khoản của bạn gắn với email: " + maskEmail(user.getEmail())
                + ". Hãy dùng email này để đăng nhập.");
        }

        req.getRequestDispatcher("/views/auth/forgot-account.jsp").forward(req, resp);
    }

    /** Che bớt email: abc@domain.com → a**c@domain.com */
    private String maskEmail(String email) {
        if (email == null || !email.contains("@")) return "***";
        String[] parts = email.split("@", 2);
        String local  = parts[0];
        String domain = parts[1];
        if (local.length() <= 2) {
            return local.charAt(0) + "***@" + domain;
        }
        return local.charAt(0) + "***" + local.charAt(local.length() - 1) + "@" + domain;
    }

    private String buildEmailBody(User user) {
        return "<html><body style='font-family:Arial,sans-serif'>"
            + "<div style='max-width:600px;margin:0 auto;padding:20px'>"
            + "<h2 style='color:#682d00'>☕ FPolyCoffee – Thông tin tài khoản</h2>"
            + "<p>Xin chào <strong>" + user.getFullName() + "</strong>,</p>"
            + "<p>Theo yêu cầu, đây là thông tin tài khoản của bạn:</p>"
            + "<div style='background:#fdf6f0;padding:16px;border-radius:8px;margin:16px 0;"
            +              "border-left:4px solid #682d00'>"
            + "<p><strong>Email đăng nhập:</strong> " + user.getEmail() + "</p>"
            + "<p style='margin:0'><strong>Số điện thoại:</strong> " + user.getPhone() + "</p>"
            + "</div>"
            + "<p>Nếu bạn quên mật khẩu, hãy dùng chức năng <strong>Quên mật khẩu</strong> "
            + "trên trang đăng nhập.</p>"
            + "<hr style='border-color:#ffdbc9;margin:20px 0'>"
            + "<p><i>Trân trọng,</i><br><strong>Đội ngũ FPolyCoffee</strong></p>"
            + "</div></body></html>";
    }
}
