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
import com.util.ParamUtil;

@WebServlet({ "/manager/staff", "/manager/staff/create", "/manager/staff/edit", "/manager/staff/delete",
        "/manager/staff/toggle-status" })
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

        String uri = req.getRequestURI();

        if (uri.contains("/create")) {
            // Hiển thị form thêm nhân viên
            showCreateForm(req, resp);
        } else if (uri.contains("/edit")) {
            // Hiển thị form sửa nhân viên
            showEditForm(req, resp);
        } else {
            // Hiển thị danh sách
            listStaff(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String uri = req.getRequestURI();

        if (uri.contains("/create")) {
            createStaff(req, resp);
        } else if (uri.contains("/edit")) {
            updateStaff(req, resp);
        } else if (uri.contains("/delete")) {
            deleteStaff(req, resp);
        } else if (uri.contains("/toggle-status")) {
            toggleStatus(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/manager/staff");
        }
    }

    private void listStaff(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
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

    private void showCreateForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/views/staff/form.jsp").forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = ParamUtil.getInt(req, "id");
        if (id <= 0) {
            req.getSession().setAttribute("error", "ID nhân viên không hợp lệ!");
            resp.sendRedirect(req.getContextPath() + "/manager/staff");
            return;
        }

        User staff = userDAO.findById(id);
        if (staff == null || staff.getRoleId() != 2) {
            req.getSession().setAttribute("error", "Không tìm thấy nhân viên!");
            resp.sendRedirect(req.getContextPath() + "/manager/staff");
            return;
        }

        req.setAttribute("staff", staff);
        req.getRequestDispatcher("/views/staff/form.jsp").forward(req, resp);
    }

    private void createStaff(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String fullName = ParamUtil.getString(req, "fullName");
        String email = ParamUtil.getString(req, "email");
        String phone = ParamUtil.getString(req, "phone");
        String password = ParamUtil.getString(req, "password");

        // Validate
        if (fullName == null || fullName.trim().isEmpty()) {
            req.getSession().setAttribute("error", "Họ tên không được để trống!");
            resp.sendRedirect(req.getContextPath() + "/manager/staff/create");
            return;
        }

        // Check email trùng
        if (userDAO.findByEmailAny(email) != null) {
            req.getSession().setAttribute("error", "Email đã tồn tại!");
            resp.sendRedirect(req.getContextPath() + "/manager/staff/create");
            return;
        }

        // Check phone trùng
        if (userDAO.findByPhone(phone) != null) {
            req.getSession().setAttribute("error", "Số điện thoại đã tồn tại!");
            resp.sendRedirect(req.getContextPath() + "/manager/staff/create");
            return;
        }

        User newStaff = new User();
        newStaff.setFullName(fullName);
        newStaff.setEmail(email);
        newStaff.setPhone(phone);
        newStaff.setPassword(password != null && !password.isEmpty() ? password : "123456");
        newStaff.setActive(true);
        newStaff.setRoleId(2); // Nhân viên

        int result = userDAO.create(newStaff);

        if (result > 0) {
            req.getSession().setAttribute("message", "Thêm nhân viên thành công!");
        } else {
            req.getSession().setAttribute("error", "Thêm nhân viên thất bại!");
        }

        resp.sendRedirect(req.getContextPath() + "/manager/staff");
    }

    private void updateStaff(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = ParamUtil.getInt(req, "id");
        String fullName = ParamUtil.getString(req, "fullName");
        String email = ParamUtil.getString(req, "email");
        String phone = ParamUtil.getString(req, "phone");

        if (id <= 0) {
            req.getSession().setAttribute("error", "ID nhân viên không hợp lệ!");
            resp.sendRedirect(req.getContextPath() + "/manager/staff");
            return;
        }

        User staff = userDAO.findById(id);
        if (staff == null || staff.getRoleId() != 2) {
            req.getSession().setAttribute("error", "Không tìm thấy nhân viên!");
            resp.sendRedirect(req.getContextPath() + "/manager/staff");
            return;
        }

        // Check email trùng (trừ chính nó)
        User existEmail = userDAO.findByEmailAny(email);
        if (existEmail != null && !existEmail.getId().equals(id)) {
            req.getSession().setAttribute("error", "Email đã tồn tại!");
            resp.sendRedirect(req.getContextPath() + "/manager/staff/edit?id=" + id);
            return;
        }

        // Check phone trùng (trừ chính nó)
        User existPhone = userDAO.findByPhone(phone);
        if (existPhone != null && !existPhone.getId().equals(id)) {
            req.getSession().setAttribute("error", "Số điện thoại đã tồn tại!");
            resp.sendRedirect(req.getContextPath() + "/manager/staff/edit?id=" + id);
            return;
        }

        staff.setFullName(fullName);
        staff.setEmail(email);
        staff.setPhone(phone);

        int result = userDAO.update(staff);

        if (result > 0) {
            req.getSession().setAttribute("message", "Cập nhật nhân viên thành công!");
        } else {
            req.getSession().setAttribute("error", "Cập nhật nhân viên thất bại!");
        }

        resp.sendRedirect(req.getContextPath() + "/manager/staff");
    }

    private void deleteStaff(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = ParamUtil.getInt(req, "id");

        if (id <= 0) {
            req.getSession().setAttribute("error", "ID nhân viên không hợp lệ!");
            resp.sendRedirect(req.getContextPath() + "/manager/staff");
            return;
        }

        User staff = userDAO.findById(id);
        if (staff == null || staff.getRoleId() != 2) {
            req.getSession().setAttribute("error", "Không tìm thấy nhân viên!");
            resp.sendRedirect(req.getContextPath() + "/manager/staff");
            return;
        }

        int result = userDAO.delete(id);

        if (result > 0) {
            req.getSession().setAttribute("message", "Xóa nhân viên thành công!");
        } else {
            req.getSession().setAttribute("error", "Xóa nhân viên thất bại!");
        }

        resp.sendRedirect(req.getContextPath() + "/manager/staff");
    }

    private void toggleStatus(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = ParamUtil.getInt(req, "id");

        if (id <= 0) {
            req.getSession().setAttribute("error", "ID nhân viên không hợp lệ!");
            resp.sendRedirect(req.getContextPath() + "/manager/staff");
            return;
        }

        User staff = userDAO.findById(id);
        if (staff == null || staff.getRoleId() != 2) {
            req.getSession().setAttribute("error", "Không tìm thấy nhân viên!");
            resp.sendRedirect(req.getContextPath() + "/manager/staff");
            return;
        }

        // Không cho khóa chính mình
        User currentUser = AuthUtil.getUser(req);
        if (currentUser != null && currentUser.getId().equals(id)) {
            req.getSession().setAttribute("error", "Bạn không thể khóa tài khoản của chính mình!");
            resp.sendRedirect(req.getContextPath() + "/manager/staff");
            return;
        }

        int result = userDAO.updateStatus(id, !staff.isActive());

        if (result > 0) {
            req.getSession().setAttribute("message",
                    staff.isActive() ? "Đã khóa tài khoản nhân viên!" : "Đã mở khóa tài khoản nhân viên!");
        } else {
            req.getSession().setAttribute("error", "Thao tác thất bại!");
        }

        resp.sendRedirect(req.getContextPath() + "/manager/staff");
    }
}