package com.servlet;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dao.BillDAO;
import com.dao.BillDetailDAO;
import com.dao.UserDAO;
import com.entity.Bill;
import com.entity.BillItemInfo;
import com.entity.User;
import com.util.AuthUtil;
import com.util.ParamUtil;

@WebServlet({
        "/manager/bills",
        "/manager/bills/detail",
        "/manager/bills/cancel",
        "/manager/bills/complete",
        "/manager/bills/cleanup",
        "/manager/bills/staff-stats"
})
public class BillServlet extends HttpServlet {

    private final BillDAO billDAO = new BillDAO();
    private final BillDetailDAO billDetailDAO = new BillDetailDAO();
    private final UserDAO userDAO = new UserDAO();
    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!AuthUtil.isManager(req)) {
            resp.sendRedirect(req.getContextPath() + "/trang-chu");
            return;
        }
        String uri = req.getRequestURI();
        if (uri.contains("/detail"))
            showDetail(req, resp);
        else if (uri.contains("/staff-stats"))
            showStaffStats(req, resp);
        else
            listBills(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!AuthUtil.isManager(req)) {
            resp.sendRedirect(req.getContextPath() + "/trang-chu");
            return;
        }
        String uri = req.getRequestURI();
        if (uri.contains("/cancel"))
            cancelBill(req, resp);
        else if (uri.contains("/complete"))
            completeBill(req, resp);
        else if (uri.contains("/cleanup"))
            cleanupJunkBills(req, resp);
    }

    // ─── List ───────────────────────────────────────────

    private void listBills(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Integer statusFilter = ParamUtil.getInt(req, "status", -1);
        Integer staffFilter = ParamUtil.getInt(req, "staffId", 0);
        if (staffFilter == 0)
            staffFilter = null;

        int page = Math.max(1, ParamUtil.getInt(req, "page", 1));

        List<Bill> bills = billDAO.findWithFilter(statusFilter, staffFilter, page, PAGE_SIZE);
        int total = billDAO.countWithFilter(statusFilter, staffFilter);
        int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);

        // Build staffName map cho JSP
        List<User> staffList = userDAO.findAllStaff();
        Map<Integer, String> staffMap = new LinkedHashMap<>();
        for (User u : staffList)
            staffMap.put(u.getId(), u.getFullName());

        transferFlash(req, "message");
        transferFlash(req, "error");

        req.setAttribute("bills", bills);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalRecords", total);
        req.setAttribute("statusFilter", statusFilter);
        req.setAttribute("staffFilter", staffFilter != null ? staffFilter : 0);
        req.setAttribute("staffList", staffList);
        req.setAttribute("staffMap", staffMap);
        req.setAttribute("waitingCount", billDAO.countByStatus(Bill.STATUS_WAITING));
        req.setAttribute("finishCount", billDAO.countByStatus(Bill.STATUS_FINISH));
        req.setAttribute("cancelCount", billDAO.countByStatus(Bill.STATUS_CANCEL));

        req.getRequestDispatcher("/views/bill/list.jsp").forward(req, resp);
    }

    // ─── Detail ─────────────────────────────────────────

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
        List<BillItemInfo> items = billDetailDAO.getBillItemsWithDrinkName(billId);
        req.setAttribute("bill", bill);
        req.setAttribute("items", items);
        req.setAttribute("staffName", getStaffName(bill.getUserId()));
        req.getRequestDispatcher("/views/bill/detail.jsp").forward(req, resp);
    }

    // ─── Staff stats ─────────────────────────────────────

    private void showStaffStats(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Object[]> stats = billDAO.getStaffSalesStats();
        req.setAttribute("stats", stats);
        req.getRequestDispatcher("/views/bill/staff-stats.jsp").forward(req, resp);
    }

    // ─── Cleanup junk bills ──────────────────────────────

    private void cleanupJunkBills(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        int deleted = billDAO.deleteAllJunkBills();
        if (deleted > 0) {
            req.getSession().setAttribute("message",
                    "Đã xóa " + deleted + " phiếu rác (đã hủy, 0₫)!");
        } else {
            req.getSession().setAttribute("message", "Không có phiếu rác nào cần xóa.");
        }
        resp.sendRedirect(req.getContextPath() + "/manager/bills");
    }

    // ─── Cancel / Complete ───────────────────────────────

    private void cancelBill(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        int billId = ParamUtil.getInt(req, "id");
        Bill bill = billDAO.findById(billId);
        if (bill == null || bill.getStatus() != Bill.STATUS_WAITING) {
            req.getSession().setAttribute("error", "Không thể hủy đơn này!");
            resp.sendRedirect(req.getContextPath() + "/manager/bills");
            return;
        }
        int result = billDAO.cancelBill(billId);
        req.getSession().setAttribute(result > 0 ? "message" : "error",
                result > 0 ? "Hủy đơn #" + bill.getCode() + " thành công!" : "Hủy đơn thất bại!");
        resp.sendRedirect(req.getContextPath() + "/manager/bills");
    }

    private void completeBill(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        int billId = ParamUtil.getInt(req, "id");
        Bill bill = billDAO.findById(billId);
        if (bill == null || bill.getStatus() != Bill.STATUS_WAITING) {
            req.getSession().setAttribute("error", "Không thể hoàn thành đơn này!");
            resp.sendRedirect(req.getContextPath() + "/manager/bills");
            return;
        }
        int result = billDAO.completeBill(billId);
        req.getSession().setAttribute(result > 0 ? "message" : "error",
                result > 0 ? "Hoàn thành đơn #" + bill.getCode() + "!" : "Cập nhật thất bại!");
        resp.sendRedirect(req.getContextPath() + "/manager/bills");
    }

    // ─── Helper ─────────────────────────────────────────

    private String getStaffName(Integer userId) {
        if (userId == null)
            return "Không xác định";
        User user = userDAO.findById(userId);
        return user != null ? user.getFullName() : "Không xác định";
    }

    private void transferFlash(HttpServletRequest req, String key) {
        Object v = req.getSession().getAttribute(key);
        if (v != null) {
            req.setAttribute(key, v);
            req.getSession().removeAttribute(key);
        }
    }
}
