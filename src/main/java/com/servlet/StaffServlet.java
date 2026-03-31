package com.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dao.UserDAO;
import com.entity.User;
import com.util.AuthUtil;
import com.util.Mailer;
import com.util.ParamUtil;

@WebServlet({ "/manager/staff", "/manager/staff/reset-password" })
public class StaffServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Kiểm tra quyền (chỉ manager mới được truy cập)
        if (!AuthUtil.isManager(req)) {
            resp.sendRedirect(req.getContextPath() + "/trang-chu");
            return;
        }

        // Lấy tham số tìm kiếm
        String searchName = ParamUtil.getString(req, "searchName");
        String searchEmail = ParamUtil.getString(req, "searchEmail");
        String statusStr = ParamUtil.getString(req, "status");
        Boolean active = null;
        if (statusStr != null && !statusStr.isEmpty()) {
            active = "active".equals(statusStr);
        }

        // Lấy số trang
        int page = ParamUtil.getInt(req, "page", 1);
        if (page < 1)
            page = 1;

        // Tìm kiếm và phân trang
        List<User> staffList = userDAO.searchStaff(searchName, searchEmail, active, page, PAGE_SIZE);
        int totalRecords = userDAO.countSearchStaff(searchName, searchEmail, active);
        int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);

        // Gửi dữ liệu sang JSP
        req.setAttribute("staffList", staffList);
        req.setAttribute("searchName", searchName);
        req.setAttribute("searchEmail", searchEmail);
        req.setAttribute("selectedStatus", statusStr);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalRecords", totalRecords);

        req.getRequestDispatcher("/views/staff/list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String uri = req.getRequestURI();

        if (uri.contains("/reset-password")) {
            resetPassword(req, resp);
        } else {
            // Xử lý cập nhật thông tin nhân viên (tùy chọn)
            updateStaff(req);
            resp.sendRedirect(req.getContextPath() + "/manager/staff");
        }
    }

    private void resetPassword(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int staffId = ParamUtil.getInt(req, "id");
        if (staffId <= 0) {
            req.getSession().setAttribute("error", "ID nhân viên không hợp lệ!");
            resp.sendRedirect(req.getContextPath() + "/manager/staff");
            return;
        }

        User staff = userDAO.findById(staffId);
        if (staff == null || staff.getRoleId() != 2) {
            req.getSession().setAttribute("error", "Không tìm thấy nhân viên!");
            resp.sendRedirect(req.getContextPath() + "/manager/staff");
            return;
        }

        // Random mật khẩu mới (6 ký tự)
        String newPassword = generateRandomPassword(6);

        // Cập nhật vào database
        int result = userDAO.resetPassword(staffId, newPassword);

        if (result > 0) {
            // Gửi email
            String subject = "[FPolyCoffee] Mật khẩu mới của bạn";
            String body = buildEmailBody(staff.getFullName(), newPassword);

            int mailResult = Mailer.send("vythaianh2021@gmail.com", staff.getEmail(), subject, body);

            if (mailResult > 0) {
                req.getSession().setAttribute("message",
                        "Đã cấp lại mật khẩu cho nhân viên " + staff.getFullName() +
                                ". Mật khẩu mới đã được gửi đến email " + staff.getEmail());
            } else {
                req.getSession().setAttribute("error",
                        "Đã cập nhật mật khẩu nhưng gửi email thất bại!");
            }
        } else {
            req.getSession().setAttribute("error", "Cập nhật mật khẩu thất bại!");
        }

        resp.sendRedirect(req.getContextPath() + "/manager/staff");
    }

    private void updateStaff(HttpServletRequest req) {
        // Có thể thêm chức năng cập nhật thông tin nhân viên
        // Tạm thời để trống
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
        return "<html><body>" +
                "<h2>Xin chào " + fullName + ",</h2>" +
                "<p>Hệ thống FPolyCoffee đã cấp lại mật khẩu mới cho bạn.</p>" +
                "<p><strong>Mật khẩu mới của bạn là: " + newPassword + "</strong></p>" +
                "<hr>" +
                "<p><i>Trân trọng,</i><br>Đội ngũ FPolyCoffee</p>" +
                "</body></html>";
    }
}