package com.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dao.CategoryDAO;
import com.dao.DrinkDAO;
import com.entity.Category;
import com.entity.Drink;
import com.util.FileUtil;
import com.util.ParamUtil;

@WebServlet({
        "/manager/drinks",
        "/manager/drinks/add",
        "/manager/drinks/edit",
        "/manager/drinks/delete",
        "/manager/drinks/toggle-status"
})
@MultipartConfig
public class DrinkServlet extends HttpServlet {

    private final DrinkDAO drinkDAO = new DrinkDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private static final int PAGE_SIZE = 10;

    // ─────────────── GET ───────────────

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String uri = req.getRequestURI();

        // Form chỉnh sửa — load đồ uống theo id
        if (uri.contains("/edit")) {
            int id = ParamUtil.getInt(req, "id");
            if (id > 0) {
                req.setAttribute("drink", drinkDAO.findById(id));
            }
        }

        // Tham số tìm kiếm
        String searchName = ParamUtil.getString(req, "searchName");
        Integer categoryId = ParamUtil.getInt(req, "categoryId", 0);
        String statusStr = ParamUtil.getString(req, "status");
        Boolean active = null;
        if (statusStr != null && !statusStr.isEmpty()) {
            active = "active".equals(statusStr);
        }

        // Phân trang
        int page = ParamUtil.getInt(req, "page", 1);
        if (page < 1)
            page = 1;

        List<Drink> drinks = drinkDAO.searchAndPaginate(
                searchName, categoryId > 0 ? categoryId : null, active, page, PAGE_SIZE);
        int totalRecords = drinkDAO.countSearch(
                searchName, categoryId > 0 ? categoryId : null, active);
        int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);
        List<Category> categories = categoryDAO.findAllActive();

        req.setAttribute("drinks", drinks);
        req.setAttribute("categories", categories);
        req.setAttribute("searchName", searchName);
        req.setAttribute("selectedCategoryId", categoryId);
        req.setAttribute("selectedStatus", statusStr);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalRecords", totalRecords);

        // Flash messages từ redirect
        transferFlash(req, "message");
        transferFlash(req, "error");

        req.getRequestDispatcher("/views/drink/manager-list.jsp").forward(req, resp);
    }

    // ─────────────── POST ──────────────

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String uri = req.getRequestURI();

        if (uri.contains("/add"))
            create(req);
        else if (uri.contains("/edit"))
            update(req);
        else if (uri.contains("/toggle-status"))
            toggleStatus(req);
        else if (uri.contains("/delete"))
            delete(req);

        resp.sendRedirect(req.getContextPath() + "/manager/drinks");
    }

    // ─────────────── Handlers ──────────

    private void create(HttpServletRequest req) {
        try {
            String name = ParamUtil.getString(req, "name");
            if (name == null || name.isBlank()) {
                req.getSession().setAttribute("error", "Tên đồ uống không được để trống!");
                return;
            }
            double price = ParamUtil.getDouble(req, "price", 0);
            if (price <= 0) {
                req.getSession().setAttribute("error", "Giá phải lớn hơn 0!");
                return;
            }
            int catId = ParamUtil.getInt(req, "categoryId", 0);
            if (catId <= 0) {
                req.getSession().setAttribute("error", "Vui lòng chọn danh mục!");
                return;
            }
            String desc = ParamUtil.getString(req, "description", "");
            boolean active = ParamUtil.getBoolean(req, "active");
            String image = FileUtil.upload(req, "image");

            Drink drink = new Drink(null, name, price, desc,
                    image == null ? "" : image, active, catId);

            int r = drinkDAO.create(drink);
            req.getSession().setAttribute(r > 0 ? "message" : "error",
                    r > 0 ? "Thêm \"" + name + "\" thành công!" : "Thêm thất bại!");
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
        }
    }

    private void update(HttpServletRequest req) {
        try {
            int id = ParamUtil.getInt(req, "id");
            Drink drink = drinkDAO.findById(id);
            if (drink == null) {
                req.getSession().setAttribute("error", "Không tìm thấy đồ uống!");
                return;
            }
            String name = ParamUtil.getString(req, "name");
            if (name == null || name.isBlank()) {
                req.getSession().setAttribute("error", "Tên đồ uống không được để trống!");
                return;
            }
            double price = ParamUtil.getDouble(req, "price", 0);
            if (price <= 0) {
                req.getSession().setAttribute("error", "Giá phải lớn hơn 0!");
                return;
            }
            int catId = ParamUtil.getInt(req, "categoryId", 0);
            if (catId <= 0) {
                req.getSession().setAttribute("error", "Vui lòng chọn danh mục!");
                return;
            }
            drink.setName(name);
            drink.setPrice(price);
            drink.setCategoryId(catId);
            drink.setDescription(ParamUtil.getString(req, "description", ""));
            drink.setActive(ParamUtil.getBoolean(req, "active"));

            String newImage = FileUtil.upload(req, "image");
            if (newImage != null && !newImage.isEmpty())
                drink.setImage(newImage);

            int r = drinkDAO.update(drink);
            req.getSession().setAttribute(r > 0 ? "message" : "error",
                    r > 0 ? "Cập nhật \"" + name + "\" thành công!" : "Cập nhật thất bại!");
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
        }
    }

    /**
     * Toggle active/inactive — cho phép cả MỞ lại đồ uống đã ẩn.
     * Thay vì softDelete chỉ đặt active=false, hàm này đảo ngược trạng thái.
     */
    private void toggleStatus(HttpServletRequest req) {
        int id = ParamUtil.getInt(req, "id");
        Drink drink = drinkDAO.findById(id);
        if (drink == null) {
            req.getSession().setAttribute("error", "Không tìm thấy đồ uống!");
            return;
        }
        drink.setActive(!drink.isActive());
        int r = drinkDAO.update(drink);
        if (r > 0) {
            req.getSession().setAttribute("message",
                    "\"" + drink.getName() + "\" đã " + (drink.isActive() ? "mở bán" : "ngừng bán") + "!");
        } else {
            req.getSession().setAttribute("error", "Cập nhật trạng thái thất bại!");
        }
    }

    /** Xóa vật lý nếu không có bill, ngược lại chỉ ẩn */
    private void delete(HttpServletRequest req) {
        int id = ParamUtil.getInt(req, "id");
        Drink drink = drinkDAO.findById(id);
        if (drink == null) {
            req.getSession().setAttribute("error", "Không tìm thấy đồ uống!");
            return;
        }
        if (drinkDAO.isUsedInBill(id)) {
            int r = drinkDAO.softDelete(id);
            req.getSession().setAttribute(r > 0 ? "message" : "error",
                    r > 0
                            ? "\"" + drink.getName() + "\" đang có trong bill nên đã được ẩn thay vì xóa!"
                            : "Thao tác thất bại!");
        } else {
            int r = drinkDAO.delete(id);
            req.getSession().setAttribute(r > 0 ? "message" : "error",
                    r > 0 ? "Đã xóa \"" + drink.getName() + "\" thành công!" : "Xóa thất bại!");
        }
    }

    private void transferFlash(HttpServletRequest req, String key) {
        Object v = req.getSession().getAttribute(key);
        if (v != null) {
            req.setAttribute(key, v);
            req.getSession().removeAttribute(key);
        }
    }
}
