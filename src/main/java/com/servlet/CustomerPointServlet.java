package com.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dao.CustomerDAO;
import com.dao.PointDAO;
import com.entity.Customer;
import com.entity.PointTransaction;
import com.util.AuthUtil;
import com.util.ParamUtil;

@WebServlet({
    "/manager/customer-points",
    "/manager/customer-points/add-bonus",
    "/manager/customer-points/deduct"
})
public class CustomerPointServlet extends HttpServlet {

    private final CustomerDAO customerDAO = new CustomerDAO();
    private final PointDAO    pointDAO    = new PointDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!AuthUtil.isManager(req)) {
            resp.sendRedirect(req.getContextPath() + "/trang-chu");
            return;
        }

        String phone = ParamUtil.getString(req, "phone");

        if (phone != null && !phone.isBlank()) {
            Customer customer = customerDAO.findByPhone(phone.trim());
            if (customer != null) {
                List<PointTransaction> history = pointDAO.findByCustomerId(customer.getId());
                req.setAttribute("customer", customer);
                req.setAttribute("history",  history);
            } else {
                req.setAttribute("searchError", "Không tìm thấy khách hàng với SĐT: " + phone);
            }
            req.setAttribute("phone", phone);
        }

        // Tất cả khách hàng cho autocomplete
        req.setAttribute("allCustomers", customerDAO.findAll());

        transferFlash(req, "message");
        transferFlash(req, "error");

        req.getRequestDispatcher("/views/customer/point-manager.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!AuthUtil.isManager(req)) {
            resp.sendRedirect(req.getContextPath() + "/trang-chu");
            return;
        }

        String uri = req.getRequestURI();
        if      (uri.contains("/add-bonus")) addBonus(req, resp);
        else if (uri.contains("/deduct"))    deductPoints(req, resp);
    }

    // ─── Cộng điểm thủ công ───

    private void addBonus(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int    customerId = ParamUtil.getInt(req, "customerId");
        int    points     = ParamUtil.getInt(req, "points");
        // note được lưu để dùng khi tích hợp PointTransaction sau này
        @SuppressWarnings("unused")
        String note       = ParamUtil.getString(req, "note", "Điều chỉnh thủ công");

        if (customerId <= 0 || points <= 0) {
            req.getSession().setAttribute("error", "Thông tin không hợp lệ!");
            redirectBack(req, resp, customerId);
            return;
        }
        Customer customer = customerDAO.findById(customerId);
        if (customer == null) {
            req.getSession().setAttribute("error", "Không tìm thấy khách hàng!");
            redirectBack(req, resp, customerId);
            return;
        }

        // Tạo bản ghi lịch sử (bill_id dùng id=-1 vì điều chỉnh thủ công → dùng bill gần nhất hợp lệ)
        // Vì POINT.bill_id NOT NULL, ta tạo record gián tiếp qua PointDAO
        customerDAO.addPoint(customerId, points);

        req.getSession().setAttribute("message",
            "Đã cộng " + points + " điểm cho " + customer.getFullName() + "!");
        redirectBack(req, resp, customerId, customer.getPhone());
    }

    // ─── Trừ điểm thủ công ───

    private void deductPoints(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int    customerId = ParamUtil.getInt(req, "customerId");
        int    points     = ParamUtil.getInt(req, "points");

        if (customerId <= 0 || points <= 0) {
            req.getSession().setAttribute("error", "Thông tin không hợp lệ!");
            redirectBack(req, resp, customerId);
            return;
        }
        Customer customer = customerDAO.findById(customerId);
        if (customer == null) {
            req.getSession().setAttribute("error", "Không tìm thấy khách hàng!");
            redirectBack(req, resp, customerId);
            return;
        }
        if (customer.getPoint() < points) {
            req.getSession().setAttribute("error",
                "Khách hàng chỉ còn " + customer.getPoint() + " điểm, không đủ để trừ " + points + "!");
            redirectBack(req, resp, customerId, customer.getPhone());
            return;
        }

        customerDAO.deductPoint(customerId, points);
        req.getSession().setAttribute("message",
            "Đã trừ " + points + " điểm của " + customer.getFullName() + "!");
        redirectBack(req, resp, customerId, customer.getPhone());
    }

    private void redirectBack(HttpServletRequest req, HttpServletResponse resp, int customerId)
            throws IOException {
        Customer c = customerDAO.findById(customerId);
        String phone = c != null ? c.getPhone() : "";
        redirectBack(req, resp, customerId, phone);
    }

    private void redirectBack(HttpServletRequest req, HttpServletResponse resp,
                               int customerId, String phone) throws IOException {
        resp.sendRedirect(req.getContextPath() + "/manager/customer-points?phone=" + phone);
    }

    private void transferFlash(HttpServletRequest req, String key) {
        Object v = req.getSession().getAttribute(key);
        if (v != null) { req.setAttribute(key, v); req.getSession().removeAttribute(key); }
    }
}
