package com.servlet;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dao.DiscountCodeDAO;
import com.entity.DiscountCode;
import com.util.AuthUtil;
import com.util.ParamUtil;

@WebServlet({
    "/manager/discount-codes",
    "/manager/discount-codes/add",
    "/manager/discount-codes/edit",
    "/manager/discount-codes/delete",
    "/manager/discount-codes/toggle"
})
public class DiscountCodeServlet extends HttpServlet {

    private final DiscountCodeDAO dao = new DiscountCodeDAO();
    private static final SimpleDateFormat SDF = new SimpleDateFormat("yyyy-MM-dd");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!AuthUtil.isManager(req)) {
            resp.sendRedirect(req.getContextPath() + "/trang-chu");
            return;
        }

        String uri = req.getRequestURI();
        if (uri.contains("/edit")) {
            int id = ParamUtil.getInt(req, "id");
            req.setAttribute("editing", dao.findById(id));
        }

        transferFlash(req, "message");
        transferFlash(req, "error");

        req.setAttribute("list", dao.findAll());
        req.getRequestDispatcher("/views/discount/list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!AuthUtil.isManager(req)) {
            resp.sendRedirect(req.getContextPath() + "/trang-chu");
            return;
        }

        String uri = req.getRequestURI();
        if      (uri.contains("/add"))    create(req, resp);
        else if (uri.contains("/edit"))   update(req, resp);
        else if (uri.contains("/delete")) delete(req, resp);
        else if (uri.contains("/toggle")) toggle(req, resp);
        else resp.sendRedirect(req.getContextPath() + "/manager/discount-codes");
    }

    // ─────────── CRUD ───────────

    private void create(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String code        = ParamUtil.getString(req, "code");
        double value       = ParamUtil.getDouble(req, "discountValue", 0);
        boolean isPercent  = "1".equals(ParamUtil.getString(req, "discountType"));
        String startStr    = ParamUtil.getString(req, "startDate");
        String endStr      = ParamUtil.getString(req, "endDate");
        String note        = ParamUtil.getString(req, "conditionNote", "");

        // Validate
        if (code == null || code.isBlank()) {
            req.getSession().setAttribute("error", "Mã giảm giá không được để trống!");
            resp.sendRedirect(req.getContextPath() + "/manager/discount-codes");
            return;
        }
        if (value <= 0 || (isPercent && value > 100)) {
            req.getSession().setAttribute("error", isPercent
                ? "Phần trăm giảm phải từ 1 – 100!" : "Giá trị giảm phải lớn hơn 0!");
            resp.sendRedirect(req.getContextPath() + "/manager/discount-codes");
            return;
        }

        try {
            Date start = SDF.parse(startStr);
            Date end   = SDF.parse(endStr);
            if (end.before(start)) {
                req.getSession().setAttribute("error", "Ngày kết thúc phải sau ngày bắt đầu!");
                resp.sendRedirect(req.getContextPath() + "/manager/discount-codes");
                return;
            }
            DiscountCode dc = new DiscountCode(null, code.toUpperCase().trim(),
                value, isPercent, start, end, true, note);
            int r = dao.create(dc);
            req.getSession().setAttribute(r > 0 ? "message" : "error",
                r > 0 ? "Thêm mã \"" + dc.getCode() + "\" thành công!" : "Thêm thất bại!");
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Ngày không hợp lệ: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/manager/discount-codes");
    }

    private void update(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int    id         = ParamUtil.getInt(req, "id");
        double value      = ParamUtil.getDouble(req, "discountValue", 0);
        boolean isPercent = "1".equals(ParamUtil.getString(req, "discountType"));
        String startStr   = ParamUtil.getString(req, "startDate");
        String endStr     = ParamUtil.getString(req, "endDate");
        String note       = ParamUtil.getString(req, "conditionNote", "");

        DiscountCode dc = dao.findById(id);
        if (dc == null) {
            req.getSession().setAttribute("error", "Không tìm thấy mã!");
            resp.sendRedirect(req.getContextPath() + "/manager/discount-codes");
            return;
        }
        try {
            Date start = SDF.parse(startStr);
            Date end   = SDF.parse(endStr);
            dc.setDiscountValue(value);
            dc.setDiscountType(isPercent);
            dc.setStartDate(start);
            dc.setEndDate(end);
            dc.setConditionNote(note);
            int r = dao.update(dc);
            req.getSession().setAttribute(r > 0 ? "message" : "error",
                r > 0 ? "Cập nhật mã \"" + dc.getCode() + "\" thành công!" : "Cập nhật thất bại!");
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/manager/discount-codes");
    }

    private void delete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = ParamUtil.getInt(req, "id");
        DiscountCode dc = dao.findById(id);
        if (dc != null) {
            dao.delete(id);
            req.getSession().setAttribute("message", "Đã xóa mã \"" + dc.getCode() + "\"!");
        } else {
            req.getSession().setAttribute("error", "Không tìm thấy mã!");
        }
        resp.sendRedirect(req.getContextPath() + "/manager/discount-codes");
    }

    private void toggle(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = ParamUtil.getInt(req, "id");
        DiscountCode dc = dao.findById(id);
        if (dc != null) {
            dc.setActive(!dc.isActive());
            dao.update(dc);
            req.getSession().setAttribute("message",
                "Mã \"" + dc.getCode() + "\" đã " + (dc.isActive() ? "kích hoạt" : "vô hiệu hoá") + "!");
        }
        resp.sendRedirect(req.getContextPath() + "/manager/discount-codes");
    }

    private void transferFlash(HttpServletRequest req, String key) {
        Object v = req.getSession().getAttribute(key);
        if (v != null) { req.setAttribute(key, v); req.getSession().removeAttribute(key); }
    }
}
