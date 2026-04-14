package com.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dao.BillDAO;
import com.dao.CategoryDAO;
import com.dao.DrinkDAO;
import com.entity.Bill;
import com.entity.Category;
import com.entity.Drink;
import com.entity.User;
import com.util.AuthUtil;

@WebServlet("/trang-chu")
public class HomeServlet extends HttpServlet {

    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final DrinkDAO    drinkDAO    = new DrinkDAO();
    private final BillDAO     billDAO     = new BillDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Dữ liệu thực đơn cho mọi người dùng
        List<Category> categories = categoryDAO.findAllActive();
        List<Drink>    drinks     = drinkDAO.findAllActive();
        req.setAttribute("categories", categories);
        req.setAttribute("drinks",     drinks);

        // Nhân viên đã đăng nhập: lấy phiếu đang mở của họ
        User user = AuthUtil.getUser(req);
        if (user != null) {
            List<Bill> openBills = billDAO.findWaitingByUserId(user.getId());
            req.setAttribute("openBills", openBills);
        }

        req.getRequestDispatcher("/views/home.jsp").forward(req, resp);
    }
}
