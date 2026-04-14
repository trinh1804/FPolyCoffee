package com.servlet;

import java.io.IOException;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dao.CategoryDAO;
import com.entity.Category;
import com.util.FileUtil;
import com.util.ParamUtil;

@WebServlet({ "/manager/categories", "/manager/categories/add",
        "/manager/categories/edit", "/manager/categories/delete" })
@MultipartConfig
public class CategoryServlet extends HttpServlet {

    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = ParamUtil.getInt(req, "id");
        if (id > 0) {
            req.setAttribute("category", categoryDAO.findById(id));
        }
        List<Category> list = categoryDAO.findAll();
        req.setAttribute("list", list);
        req.getRequestDispatcher("/views/categories/list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String uri = req.getRequestURI();
        if (uri.contains("/add"))
            create(req);
        if (uri.contains("/edit"))
            update(req);
        if (uri.contains("/delete"))
            delete(req);

        req.setAttribute("list", categoryDAO.findAll());
        req.getRequestDispatcher("/views/categories/list.jsp").forward(req, resp);
    }

    private void create(HttpServletRequest req) {
        String name = ParamUtil.getString(req, "name");
        if (name == null || name.isBlank()) {
            req.setAttribute("error", "Tên danh mục không được để trống!");
            return;
        }
        String description = ParamUtil.getString(req, "description");
        String imageName = uploadImage(req);

        Category cat = new Category(null, name,
                description == null ? "" : description,
                imageName == null ? "" : imageName,
                true, new Date());
        int rs = categoryDAO.create(cat);
        req.setAttribute(rs > 0 ? "message" : "error",
                rs > 0 ? "Thêm thành công!" : "Thêm thất bại!");
    }

    private void update(HttpServletRequest req) {
        int id = ParamUtil.getInt(req, "id");
        Category cat = categoryDAO.findById(id);
        if (cat == null) {
            req.setAttribute("error", "Không tìm thấy danh mục!");
            return;
        }

        String name = ParamUtil.getString(req, "name");
        if (name == null || name.isBlank()) {
            req.setAttribute("error", "Tên danh mục không được để trống!");
            req.setAttribute("category", cat);
            return;
        }

        cat.setName(name);
        String desc = ParamUtil.getString(req, "description");
        if (desc != null)
            cat.setDescription(desc);

        String newImage = uploadImage(req);
        if (newImage != null && !newImage.isBlank())
            cat.setImage(newImage);

        int rs = categoryDAO.update(cat);
        req.setAttribute(rs > 0 ? "message" : "error",
                rs > 0 ? "Cập nhật thành công!" : "Cập nhật thất bại!");
        req.setAttribute("category", cat);
    }

    private void delete(HttpServletRequest req) {
        int id = ParamUtil.getInt(req, "id");
        if (id <= 0) {
            req.setAttribute("error", "Không tìm thấy danh mục!");
            return;
        }
        Category cat = categoryDAO.findById(id);
        if (cat == null) {
            req.setAttribute("error", "Không tìm thấy danh mục!");
            return;
        }
        // Đổi trạng thái ẩn/hiện thay vì xóa vật lý
        boolean newActive = !cat.isActive();
        cat.setActive(newActive);
        categoryDAO.update(cat);
        req.setAttribute("message",
                newActive ? "Đã mở hiển thị danh mục «" + cat.getName() + "»!"
                        : "Đã ẩn danh mục «" + cat.getName() + "»!");
        req.setAttribute("category", null);
    }

    private String uploadImage(HttpServletRequest req) {
        try {
            return FileUtil.upload(req, "image");
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }
}