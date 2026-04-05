package com.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dao.BillDAO;
import com.dao.BillDetailDAO;
import com.entity.Bill;
import com.entity.BillItemInfo;
import com.util.AuthUtil;
import com.util.ParamUtil;

@WebServlet({ "/manager/bills", "/manager/bills/detail", "/manager/bills/cancel", "/manager/bills/complete" })
public class BillServlet extends HttpServlet {

    private final BillDAO billDAO = new BillDAO();
    private final BillDetailDAO billDetailDAO = new BillDetailDAO();
    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Kiểm tra quyền admin
        if (!AuthUtil.isManager(req)) {
            resp.sendRedirect(req.getContextPath() + "/trang-chu");
            return;
        }

        String uri = req.getRequestURI();

        if (uri.contains("/detail")) {
            showDetail(req, resp);
        } else {
            listBills(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String uri = req.getRequestURI();

        if (uri.contains("/cancel")) {
            cancelBill(req, resp);
        } else if (uri.contains("/complete")) {
            completeBill(req, resp);
        }
    }

    /**
     * Hiển thị danh sách hóa đơn có phân trang
     */
    private void listBills(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Lấy tham số lọc theo trạng thái
        Integer statusFilter = ParamUtil.getInt(req, "status", -1);
        int page = ParamUtil.getInt(req, "page", 1);
        if (page < 1)
            page = 1;

        List<Bill> bills;
        int totalRecords;

        if (statusFilter >= 0 && statusFilter <= 2) {
            bills = billDAO.findByStatusWithPagination(statusFilter, page, PAGE_SIZE);
            totalRecords = billDAO.countByStatus(statusFilter);
        } else {
            bills = billDAO.findAllWithPagination(page, PAGE_SIZE);
            totalRecords = billDAO.countAll();
        }

        int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);

        // Đếm số lượng theo từng trạng thái để hiển thị badge
        int waitingCount = billDAO.countByStatus(Bill.STATUS_WAITING);
        int finishCount = billDAO.countByStatus(Bill.STATUS_FINISH);
        int cancelCount = billDAO.countByStatus(Bill.STATUS_CANCEL);

        req.setAttribute("bills", bills);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalRecords", totalRecords);
        req.setAttribute("statusFilter", statusFilter);
        req.setAttribute("waitingCount", waitingCount);
        req.setAttribute("finishCount", finishCount);
        req.setAttribute("cancelCount", cancelCount);

        req.getRequestDispatcher("/views/bill/list.jsp").forward(req, resp);
    }

    /**
     * Xem chi tiết hóa đơn
     */
    private void showDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int billId = ParamUtil.getInt(req, "id");
        if (billId <= 0) {
            req.setAttribute("error", "Mã hóa đơn không hợp lệ!");
            req.getRequestDispatcher("/manager/bills").forward(req, resp);
            return;
        }

        Bill bill = billDAO.findById(billId);
        if (bill == null) {
            req.setAttribute("error", "Không tìm thấy hóa đơn!");
            req.getRequestDispatcher("/manager/bills").forward(req, resp);
            return;
        }

        // Lấy danh sách sản phẩm trong hóa đơn
        List<BillItemInfo> items = billDetailDAO.getBillItemsWithDrinkName(billId);

        // Lấy thông tin nhân viên tạo đơn
        String staffName = getStaffName(bill.getUserId());

        req.setAttribute("bill", bill);
        req.setAttribute("items", items);
        req.setAttribute("staffName", staffName);

        req.getRequestDispatcher("/views/bill/detail.jsp").forward(req, resp);
    }

    /**
     * Hủy đơn hàng
     */
    private void cancelBill(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        int billId = ParamUtil.getInt(req, "id");
        if (billId <= 0) {
            req.getSession().setAttribute("error", "Mã hóa đơn không hợp lệ!");
            resp.sendRedirect(req.getContextPath() + "/manager/bills");
            return;
        }

        Bill bill = billDAO.findById(billId);
        if (bill == null) {
            req.getSession().setAttribute("error", "Không tìm thấy hóa đơn!");
            resp.sendRedirect(req.getContextPath() + "/manager/bills");
            return;
        }

        // Chỉ hủy được đơn đang chờ (status = 0)
        if (bill.getStatus() != Bill.STATUS_WAITING) {
            req.getSession().setAttribute("error", "Chỉ có thể hủy đơn hàng đang chờ xử lý!");
            resp.sendRedirect(req.getContextPath() + "/manager/bills/detail?id=" + billId);
            return;
        }

        int result = billDAO.cancelBill(billId);

        if (result > 0) {
            req.getSession().setAttribute("message", "Hủy đơn hàng #" + bill.getCode() + " thành công!");
        } else {
            req.getSession().setAttribute("error", "Hủy đơn hàng thất bại!");
        }

        resp.sendRedirect(req.getContextPath() + "/manager/bills");
    }

    /**
     * Hoàn thành đơn hàng
     */
    private void completeBill(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        int billId = ParamUtil.getInt(req, "id");
        if (billId <= 0) {
            req.getSession().setAttribute("error", "Mã hóa đơn không hợp lệ!");
            resp.sendRedirect(req.getContextPath() + "/manager/bills");
            return;
        }

        Bill bill = billDAO.findById(billId);
        if (bill == null) {
            req.getSession().setAttribute("error", "Không tìm thấy hóa đơn!");
            resp.sendRedirect(req.getContextPath() + "/manager/bills");
            return;
        }

        // Chỉ hoàn thành được đơn đang chờ
        if (bill.getStatus() != Bill.STATUS_WAITING) {
            req.getSession().setAttribute("error", "Chỉ có thể hoàn thành đơn hàng đang chờ xử lý!");
            resp.sendRedirect(req.getContextPath() + "/manager/bills/detail?id=" + billId);
            return;
        }

        int result = billDAO.completeBill(billId);

        if (result > 0) {
            req.getSession().setAttribute("message", "Đã hoàn thành đơn hàng #" + bill.getCode());
        } else {
            req.getSession().setAttribute("error", "Cập nhật thất bại!");
        }

        resp.sendRedirect(req.getContextPath() + "/manager/bills");
    }

    /**
     * Lấy tên nhân viên theo userId
     */
    private String getStaffName(Integer userId) {
        if (userId == null)
            return "Không xác định";

        com.dao.UserDAO userDAO = new com.dao.UserDAO();
        com.entity.User user = userDAO.findById(userId);
        return user != null ? user.getFullName() : "Không xác định";
    }
}