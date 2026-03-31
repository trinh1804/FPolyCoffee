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

@WebServlet({ "/manager/drinks", "/manager/drinks/add", "/manager/drinks/edit", "/manager/drinks/delete" })
@MultipartConfig
public class DrinkServlet extends HttpServlet {

    private final DrinkDAO drinkDAO = new DrinkDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private static final int PAGE_SIZE = 10; // Mỗi trang 10 sản phẩm

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String uri = req.getRequestURI();

        // Xử lý sửa đồ uống
        if (uri.contains("/edit")) {
            int id = ParamUtil.getInt(req, "id");
            if (id > 0) {
                req.setAttribute("drink", drinkDAO.findById(id));
            }
        }

        // Lấy tham số tìm kiếm
        String searchName = ParamUtil.getString(req, "searchName");
        Integer categoryId = ParamUtil.getInt(req, "categoryId", 0);
        String statusStr = ParamUtil.getString(req, "status");
        Boolean active = null;
        if (statusStr != null && !statusStr.isEmpty()) {
            active = "active".equals(statusStr);
        }

        // Lấy số trang hiện tại
        int page = ParamUtil.getInt(req, "page", 1);
        if (page < 1)
            page = 1;

        // Tìm kiếm và phân trang
        List<Drink> drinks = drinkDAO.searchAndPaginate(searchName, categoryId > 0 ? categoryId : null, active, page,
                PAGE_SIZE);
        int totalRecords = drinkDAO.countSearch(searchName, categoryId > 0 ? categoryId : null, active);
        int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);

        // Lấy danh sách danh mục cho dropdown
        List<Category> categories = categoryDAO.findAllActive();

        // Gửi dữ liệu sang JSP
        req.setAttribute("drinks", drinks);
        req.setAttribute("categories", categories);
        req.setAttribute("searchName", searchName);
        req.setAttribute("selectedCategoryId", categoryId);
        req.setAttribute("selectedStatus", statusStr);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalRecords", totalRecords);

        req.getRequestDispatcher("/views/drink/manager-list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String uri = req.getRequestURI();

        if (uri.contains("/add")) {
            create(req);
        } else if (uri.contains("/edit")) {
            update(req);
        } else if (uri.contains("/delete")) {
            delete(req);
        }

        // Redirect về danh sách
        resp.sendRedirect(req.getContextPath() + "/manager/drinks");
    }

    private void create(HttpServletRequest req) {
        try {
            String name = ParamUtil.getString(req, "name");
            if (name == null || name.isBlank()) {
                req.setAttribute("error", "Tên đồ uống không được để trống!");
                return;
            }

            double price = ParamUtil.getDouble(req, "price", 0);
            if (price <= 0) {
                req.setAttribute("error", "Giá phải lớn hơn 0!");
                return;
            }

            int categoryId = ParamUtil.getInt(req, "categoryId", 0);
            if (categoryId <= 0) {
                req.setAttribute("error", "Vui lòng chọn danh mục!");
                return;
            }

            String description = ParamUtil.getString(req, "description", "");
            boolean active = ParamUtil.getBoolean(req, "active");
            String image = FileUtil.upload(req, "image");

            Drink drink = new Drink(null, name, price, description,
                    image == null ? "" : image,
                    active, categoryId);

            int result = drinkDAO.create(drink);
            if (result > 0) {
                req.setAttribute("message", "Thêm đồ uống thành công!");
            } else {
                req.setAttribute("error", "Thêm đồ uống thất bại!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi: " + e.getMessage());
        }
    }

    private void update(HttpServletRequest req) {
        try {
            int id = ParamUtil.getInt(req, "id");
            Drink drink = drinkDAO.findById(id);
            if (drink == null) {
                req.setAttribute("error", "Không tìm thấy đồ uống!");
                return;
            }

            String name = ParamUtil.getString(req, "name");
            if (name == null || name.isBlank()) {
                req.setAttribute("error", "Tên đồ uống không được để trống!");
                return;
            }

            double price = ParamUtil.getDouble(req, "price", 0);
            if (price <= 0) {
                req.setAttribute("error", "Giá phải lớn hơn 0!");
                return;
            }

            int categoryId = ParamUtil.getInt(req, "categoryId", 0);
            if (categoryId <= 0) {
                req.setAttribute("error", "Vui lòng chọn danh mục!");
                return;
            }

            String description = ParamUtil.getString(req, "description", "");
            boolean active = ParamUtil.getBoolean(req, "active");

            drink.setName(name);
            drink.setPrice(price);
            drink.setCategoryId(categoryId);
            drink.setDescription(description);
            drink.setActive(active);

            // Xử lý upload ảnh mới
            String newImage = FileUtil.upload(req, "image");
            if (newImage != null && !newImage.isEmpty()) {
                drink.setImage(newImage);
            }

            int result = drinkDAO.update(drink);
            if (result > 0) {
                req.setAttribute("message", "Cập nhật đồ uống thành công!");
            } else {
                req.setAttribute("error", "Cập nhật đồ uống thất bại!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi: " + e.getMessage());
        }
    }

    private void delete(HttpServletRequest req) {
        int id = ParamUtil.getInt(req, "id");
        if (id > 0) {
            int result = drinkDAO.softDelete(id);
            if (result > 0) {
                req.setAttribute("message", "Đã ẩn đồ uống!");
            } else {
                req.setAttribute("error", "Thao tác thất bại!");
            }
        }
    }
}