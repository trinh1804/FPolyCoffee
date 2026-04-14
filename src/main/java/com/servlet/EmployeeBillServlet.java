package com.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.persistence.EntityManager;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dao.BillDAO;
import com.dao.BillDetailDAO;
import com.dao.CategoryDAO;
import com.dao.CustomerDAO;
import com.dao.DiscountCodeDAO;
import com.dao.DrinkDAO;
import com.dao.PointDAO;
import com.entity.Bill;
import com.entity.BillItemInfo;
import com.entity.Category;
import com.entity.Customer;
import com.entity.DiscountCode;
import com.entity.Drink;
import com.entity.User;
import com.util.AuthUtil;
import com.util.JpaUtil;
import com.util.ParamUtil;

/**
 * Quản lý phiếu bán hàng dành cho Nhân viên.
 *
 * URL patterns:
 * GET /employee/bills — danh sách phiếu của nhân viên
 * GET /employee/bills/create — tạo phiếu mới → chuyển thẳng tới trang chỉnh sửa
 * GET /employee/bills/order — trang thêm/xóa món, áp mã, gán KH, thanh toán
 * POST /employee/bills/add-drink
 * POST /employee/bills/update-qty
 * POST /employee/bills/remove-drink
 * POST /employee/bills/apply-discount
 * POST /employee/bills/assign-customer
 * POST /employee/bills/complete
 * POST /employee/bills/cancel
 */
@WebServlet({
        "/employee/bills",
        "/employee/bills/create",
        "/employee/bills/order",
        "/employee/bills/qr",
        "/employee/bills/add-drink",
        "/employee/bills/update-qty",
        "/employee/bills/remove-drink",
        "/employee/bills/apply-discount",
        "/employee/bills/remove-discount",
        "/employee/bills/assign-customer",
        "/employee/bills/remove-customer",
        "/employee/bills/cleanup",
        "/employee/bills/delete-junk",
        "/employee/bills/complete",
        "/employee/bills/cancel"
})
public class EmployeeBillServlet extends HttpServlet {

    private final BillDAO billDAO = new BillDAO();
    private final BillDetailDAO billDetailDAO = new BillDetailDAO();
    private final DrinkDAO drinkDAO = new DrinkDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final CustomerDAO customerDAO = new CustomerDAO();
    private final DiscountCodeDAO discountCodeDAO = new DiscountCodeDAO();
    private final PointDAO pointDAO = new PointDAO();

    // ─────────────────────── GET ───────────────────────

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!AuthUtil.isAuthenticated(req)) {
            resp.sendRedirect(req.getContextPath() + "/dang-nhap");
            return;
        }

        User user = AuthUtil.getUser(req);
        String uri = req.getRequestURI();

        if (uri.endsWith("/create")) {
            handleCreate(req, resp, user);
        } else if (uri.contains("/qr")) {
            showQrPage(req, resp, user);
        } else if (uri.contains("/order")) {
            showOrderPage(req, resp, user);
        } else {
            listMyBills(req, resp, user);
        }
    }

    // ─────────────────────── POST ──────────────────────

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!AuthUtil.isAuthenticated(req)) {
            resp.sendRedirect(req.getContextPath() + "/dang-nhap");
            return;
        }

        User user = AuthUtil.getUser(req);
        String uri = req.getRequestURI();

        if (uri.contains("/add-drink"))
            addDrink(req, resp, user);
        else if (uri.contains("/update-qty"))
            updateQty(req, resp, user);
        else if (uri.contains("/remove-drink"))
            removeDrink(req, resp, user);
        else if (uri.contains("/remove-discount"))
            removeDiscount(req, resp, user);
        else if (uri.contains("/apply-discount"))
            applyDiscount(req, resp, user);
        else if (uri.contains("/remove-customer"))
            removeCustomer(req, resp, user);
        else if (uri.contains("/assign-customer"))
            assignCustomer(req, resp, user);
        else if (uri.contains("/delete-junk"))
            deleteJunkBills(req, resp, user);
        else if (uri.contains("/cleanup"))
            cleanupBills(req, resp, user);
        else if (uri.contains("/complete"))
            completeBill(req, resp, user);
        else if (uri.contains("/cancel"))
            cancelBill(req, resp, user);
    }

    // ────────────────── Handlers ───────────────────────

    /** Hiển thị danh sách phiếu của nhân viên */
    private void listMyBills(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        List<Bill> bills = billDAO.findByUserId(user.getId());
        req.setAttribute("bills", bills);

        // Flash messages từ redirect
        transferFlash(req, "message");
        transferFlash(req, "error");

        req.getRequestDispatcher("/views/employee/bill-list.jsp").forward(req, resp);
    }

    /** Tạo phiếu mới rồi redirect sang trang order */
    private void handleCreate(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException {
        Bill bill = new Bill();
        bill.setCode(billDAO.generateNextCode());
        bill.setCreatedAt(new Date());
        bill.setUserId(user.getId());
        bill.setStatus(Bill.STATUS_WAITING);
        bill.setTotalPrice(0);
        bill.setDiscountAmount(0);
        bill.setPaymentMethod(false);

        int billId = billDAO.createWithBillDetails(bill, new ArrayList<>());
        if (billId > 0) {
            resp.sendRedirect(req.getContextPath() + "/employee/bills/order?id=" + billId);
        } else {
            req.getSession().setAttribute("error", "Tạo phiếu thất bại, vui lòng thử lại!");
            resp.sendRedirect(req.getContextPath() + "/employee/bills");
        }
    }

    /** Trang quản lý phiếu: menu + giỏ hàng hiện tại */
    private void showOrderPage(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        int billId = ParamUtil.getInt(req, "id");
        if (billId <= 0) {
            resp.sendRedirect(req.getContextPath() + "/employee/bills");
            return;
        }

        try {
            Bill bill = billDAO.findByIdAndUserId(billId, user.getId());
            if (bill == null) {
                req.getSession().setAttribute("error", "Không tìm thấy phiếu!");
                resp.sendRedirect(req.getContextPath() + "/employee/bills");
                return;
            }
            if (bill.getStatus() != Bill.STATUS_WAITING) {
                req.getSession().setAttribute("error", "Phiếu này không thể chỉnh sửa!");
                resp.sendRedirect(req.getContextPath() + "/employee/bills");
                return;
            }

            // Tự động tắt mã giảm giá hết hạn
            discountCodeDAO.autoDisableExpired();

            List<BillItemInfo> items = billDetailDAO.getBillItemsWithDrinkName(billId);
            List<Category> categories = categoryDAO.findAllActive();
            List<Drink> drinks = drinkDAO.findAllActive();
            // Chỉ lấy mã còn hiệu lực (active=true VÀ trong khoảng ngày)
            List<DiscountCode> availableDiscounts = discountCodeDAO.findValidDiscounts();

            Customer customer = bill.getCustomerId() != null
                    ? customerDAO.findById(bill.getCustomerId())
                    : null;
            DiscountCode discount = bill.getDiscountId() != null
                    ? discountCodeDAO.findById(bill.getDiscountId())
                    : null;

            req.setAttribute("bill", bill);
            req.setAttribute("items", items);
            req.setAttribute("categories", categories);
            req.setAttribute("drinks", drinks);
            req.setAttribute("customer", customer);
            req.setAttribute("discount", discount);
            req.setAttribute("availableDiscounts", availableDiscounts);

            // Flash messages từ redirect
            transferFlash(req, "discountError");
            transferFlash(req, "discountMsg");
            transferFlash(req, "customerMsg");
            transferFlash(req, "customerError");
            transferFlash(req, "orderError");

            req.getRequestDispatcher("/views/employee/bill-order.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Đã xảy ra lỗi khi mở phiếu! Vui lòng thử lại.");
            resp.sendRedirect(req.getContextPath() + "/employee/bills");
        }
    }

    /** Hiển thị trang QR thanh toán toàn màn hình */
    private void showQrPage(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        int billId = ParamUtil.getInt(req, "id");
        if (billId <= 0) {
            resp.sendRedirect(req.getContextPath() + "/employee/bills");
            return;
        }
        try {
            Bill bill = billDAO.findByIdAndUserId(billId, user.getId());
            if (bill == null) {
                req.getSession().setAttribute("error", "Không tìm thấy phiếu!");
                resp.sendRedirect(req.getContextPath() + "/employee/bills");
                return;
            }
            req.setAttribute("bill", bill);
            req.getRequestDispatcher("/views/employee/qr.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/employee/bills");
        }
    }

    /** Thêm đồ uống vào phiếu (hoặc tăng số lượng nếu đã có) */
    private void addDrink(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException {
        int billId = ParamUtil.getInt(req, "billId");
        int drinkId = ParamUtil.getInt(req, "drinkId");

        if (!isOwnerAndWaiting(billId, user)) {
            resp.sendRedirect(req.getContextPath() + "/employee/bills");
            return;
        }

        billDetailDAO.addDrinkToBill(billId, drinkId);
        billDAO.recalcTotal(billId);
        resp.sendRedirect(req.getContextPath() + "/employee/bills/order?id=" + billId);
    }

    /** Cập nhật số lượng; qty=0 → xóa dòng */
    private void updateQty(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException {
        int billId = ParamUtil.getInt(req, "billId");
        int drinkId = ParamUtil.getInt(req, "drinkId");
        int qty = ParamUtil.getInt(req, "qty");

        if (!isOwnerAndWaiting(billId, user)) {
            resp.sendRedirect(req.getContextPath() + "/employee/bills");
            return;
        }

        billDetailDAO.updateQuantity(billId, drinkId, qty);
        billDAO.recalcTotal(billId);
        resp.sendRedirect(req.getContextPath() + "/employee/bills/order?id=" + billId);
    }

    /** Xóa hẳn một dòng đồ uống khỏi phiếu */
    private void removeDrink(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException {
        int billId = ParamUtil.getInt(req, "billId");
        int drinkId = ParamUtil.getInt(req, "drinkId");

        if (!isOwnerAndWaiting(billId, user)) {
            resp.sendRedirect(req.getContextPath() + "/employee/bills");
            return;
        }

        billDetailDAO.deleteByBillAndDrink(billId, drinkId);
        billDAO.recalcTotal(billId);
        resp.sendRedirect(req.getContextPath() + "/employee/bills/order?id=" + billId);
    }

    /** Gỡ mã giảm giá khỏi phiếu */
    private void removeDiscount(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException {
        int billId = ParamUtil.getInt(req, "billId");

        if (!isOwnerAndWaiting(billId, user)) {
            resp.sendRedirect(req.getContextPath() + "/employee/bills");
            return;
        }

        int rows = billDAO.removeDiscount(billId);
        if (rows > 0) {
            billDAO.recalcTotal(billId);
            req.getSession().setAttribute("discountMsg", "Đã gỡ mã giảm giá.");
        } else {
            req.getSession().setAttribute("discountError", "Gỡ mã thất bại!");
        }
        resp.sendRedirect(req.getContextPath() + "/employee/bills/order?id=" + billId);
    }

    /** Áp dụng mã giảm giá */
    private void applyDiscount(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException {
        int billId = ParamUtil.getInt(req, "billId");
        String code = ParamUtil.getString(req, "discountCode");

        if (!isOwnerAndWaiting(billId, user)) {
            resp.sendRedirect(req.getContextPath() + "/employee/bills");
            return;
        }

        DiscountCode dc = discountCodeDAO.findByCode(code);
        if (dc == null) {
            req.getSession().setAttribute("discountError",
                    "Mã \"" + code + "\" không hợp lệ hoặc đã hết hạn!");
        } else {
            // Lấy subtotal (chưa giảm) để tính chiết khấu
            Bill bill = billDAO.findById(billId);
            double subtotal = bill.getTotalPrice() + bill.getDiscountAmount();
            double amount = discountCodeDAO.calculateDiscount(dc, subtotal);

            billDAO.applyDiscount(billId, dc.getId(), amount);
            billDAO.recalcTotal(billId);
            req.getSession().setAttribute("discountMsg",
                    "Áp dụng thành công! Giảm " + String.format("%,.0f", amount) + " ₫");
        }

        resp.sendRedirect(req.getContextPath() + "/employee/bills/order?id=" + billId);
    }

    /**
     * Gán khách hàng vào phiếu theo số điện thoại.
     * Nếu chưa có → tạo mới khách hàng.
     */
    private void assignCustomer(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException {
        int billId = ParamUtil.getInt(req, "billId");
        String phone = ParamUtil.getString(req, "phone");

        if (!isOwnerAndWaiting(billId, user)) {
            resp.sendRedirect(req.getContextPath() + "/employee/bills");
            return;
        }

        Customer customer = customerDAO.findByPhone(phone);
        if (customer == null) {
            // Tạo khách hàng mới với thông tin tối thiểu
            Customer newCust = new Customer();
            newCust.setFullName("Khách " + phone);
            newCust.setPhone(phone);
            newCust.setEmail("");
            newCust.setPoint(0);
            newCust.setActive(true);
            customerDAO.create(newCust);
            customer = customerDAO.findByPhone(phone);
        }

        if (customer != null) {
            billDAO.assignCustomer(billId, customer.getId());
            req.getSession().setAttribute("customerMsg",
                    "Đã gán khách: " + customer.getFullName()
                            + " — Điểm hiện tại: " + customer.getPoint());
        } else {
            req.getSession().setAttribute("customerError", "Không thể tạo khách hàng!");
        }

        resp.sendRedirect(req.getContextPath() + "/employee/bills/order?id=" + billId);
    }

    /**
     * Hoàn thành thanh toán:
     * 1. Lưu phương thức thanh toán
     * 2. Chuyển trạng thái → FINISH
     * 3. Tích điểm cho khách hàng (nếu có)
     */
    private void completeBill(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException {
        int billId = ParamUtil.getInt(req, "billId");
        boolean paymentOnline = "online".equals(ParamUtil.getString(req, "paymentMethod"));

        if (!isOwnerAndWaiting(billId, user)) {
            req.getSession().setAttribute("error", "Không thể hoàn thành phiếu này!");
            resp.sendRedirect(req.getContextPath() + "/employee/bills");
            return;
        }

        // Kiểm tra có ít nhất 1 sản phẩm
        List<BillItemInfo> items = billDetailDAO.getBillItemsWithDrinkName(billId);
        if (items.isEmpty()) {
            req.getSession().setAttribute("orderError", "Phiếu chưa có sản phẩm nào!");
            resp.sendRedirect(req.getContextPath() + "/employee/bills/order?id=" + billId);
            return;
        }

        // Cập nhật phương thức thanh toán
        setPaymentMethod(billId, paymentOnline);

        int result = billDAO.completeBill(billId);
        if (result > 0) {
            Bill finished = billDAO.findById(billId);
            // Tích điểm nếu có khách hàng
            if (finished.getCustomerId() != null) {
                pointDAO.earnPoint(finished.getCustomerId(), billId, finished.getTotalPrice());
            }
            req.getSession().setAttribute("message",
                    "Thanh toán thành công! Mã phiếu: " + finished.getCode()
                            + " — Tổng: " + String.format("%,.0f", finished.getTotalPrice()) + " ₫");
            resp.sendRedirect(req.getContextPath() + "/employee/bills");
        } else {
            req.getSession().setAttribute("orderError", "Hoàn thành thất bại, vui lòng thử lại!");
            resp.sendRedirect(req.getContextPath() + "/employee/bills/order?id=" + billId);
        }
    }

    /** Hủy phiếu đang chờ */
    private void cancelBill(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException {
        int billId = ParamUtil.getInt(req, "billId");

        if (!isOwnerAndWaiting(billId, user)) {
            req.getSession().setAttribute("error", "Không thể hủy phiếu này!");
            resp.sendRedirect(req.getContextPath() + "/employee/bills");
            return;
        }

        Bill bill = billDAO.findById(billId);
        int result = billDAO.cancelBill(billId);
        if (result > 0) {
            req.getSession().setAttribute("message", "Đã hủy phiếu " + bill.getCode());
        } else {
            req.getSession().setAttribute("error", "Hủy phiếu thất bại!");
        }
        resp.sendRedirect(req.getContextPath() + "/employee/bills");
    }

    /** Xóa khách hàng khỏi phiếu (đặt về null) */
    private void removeCustomer(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException {
        int billId = ParamUtil.getInt(req, "billId");
        if (!isOwnerAndWaiting(billId, user)) {
            resp.sendRedirect(req.getContextPath() + "/employee/bills");
            return;
        }
        int rows = billDAO.assignCustomer(billId, null);
        if (rows > 0) {
            req.getSession().setAttribute("customerMsg", "Đã gỡ khách hàng khỏi phiếu.");
        } else {
            req.getSession().setAttribute("customerError", "Gỡ khách hàng thất bại!");
        }
        resp.sendRedirect(req.getContextPath() + "/employee/bills/order?id=" + billId);
    }

    /** Xóa các phiếu rác của nhân viên này */
    private void deleteJunkBills(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException {
        int deleted = billDAO.deleteJunkBillsByUser(user.getId());
        if (deleted > 0) {
            req.getSession().setAttribute("message", "Đã xóa " + deleted + " phiếu rác của bạn.");
        } else {
            req.getSession().setAttribute("message", "Không có phiếu rác nào cần xóa.");
        }
        resp.sendRedirect(req.getContextPath() + "/employee/bills");
    }

    /** Cleanup bills, redirect to deleteJunkBills */
    private void cleanupBills(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException {
        deleteJunkBills(req, resp, user);
    }

    // ──────────────────── Helpers ──────────────────────

    /** Kiểm tra phiếu thuộc user và đang ở trạng thái WAITING */
    private boolean isOwnerAndWaiting(int billId, User user) {
        Bill bill = billDAO.findByIdAndUserId(billId, user.getId());
        return bill != null && bill.getStatus() == Bill.STATUS_WAITING;
    }

    /** Cập nhật phương thức thanh toán */
    private void setPaymentMethod(int billId, boolean online) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.createQuery("UPDATE Bill b SET b.paymentMethod = ?1 WHERE b.id = ?2")
                    .setParameter(1, online)
                    .setParameter(2, billId)
                    .executeUpdate();
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive())
                em.getTransaction().rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    /** Chuyển flash message từ session sang request attribute */
    private void transferFlash(HttpServletRequest req, String key) {
        Object val = req.getSession().getAttribute(key);
        if (val != null) {
            req.setAttribute(key, val);
            req.getSession().removeAttribute(key);
        }
    }
}