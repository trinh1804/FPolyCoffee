package com.servlet;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dao.BillDAO;
import com.dao.DrinkDAO;
import com.dao.StatisticDAO;
import com.dao.UserDAO;
import com.entity.BestSellingDrink;
import com.entity.Bill;
import com.entity.RevenueByDay;
import com.util.AuthUtil;
import com.util.ParamUtil;

@WebServlet("/manager/report")
public class ReportServlet extends HttpServlet {

    private final StatisticDAO statisticDAO = new StatisticDAO();
    private final UserDAO userDAO = new UserDAO();
    private final DrinkDAO drinkDAO = new DrinkDAO();
    private final BillDAO billDAO = new BillDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!AuthUtil.isManager(req)) {
            resp.sendRedirect(req.getContextPath() + "/trang-chu");
            return;
        }

        // Lấy tham số khoảng thời gian
        String fromDateStr = ParamUtil.getString(req, "fromDate");
        String toDateStr = ParamUtil.getString(req, "toDate");

        Date fromDate = null;
        Date toDate = null;

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        try {
            if (fromDateStr != null && !fromDateStr.isEmpty()) {
                fromDate = sdf.parse(fromDateStr);
            }
            if (toDateStr != null && !toDateStr.isEmpty()) {
                toDate = sdf.parse(toDateStr);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Nếu không có tham số, lấy mặc định 7 ngày gần nhất
        if (fromDate == null || toDate == null) {
            Calendar cal = Calendar.getInstance();
            toDate = cal.getTime();
            cal.add(Calendar.DAY_OF_MONTH, -7);
            fromDate = cal.getTime();
            fromDateStr = sdf.format(fromDate);
            toDateStr = sdf.format(toDate);
        }

        // Tổng số đồ uống đang bán (active = true)
        int totalDrinks = drinkDAO.findAllActive().size();

        // Tổng số nhân viên (roleId = 2)
        int totalStaff = userDAO.findAllStaff().size();

        // Doanh thu hôm nay (lấy ngày hiện tại)
        Date today = new Date();
        Date startOfDay = getStartOfDay(today);
        Date endOfDay = getEndOfDay(today);
        double todayRevenue = billDAO.getTotalRevenueByDateRange(startOfDay, endOfDay);

        // Tính số đơn hoàn thành hôm nay
        int todayFinishedBills = 0;
        try {
            List<Bill> todayBillsList = billDAO.findByDateRange(startOfDay, endOfDay);
            todayFinishedBills = todayBillsList.size();
        } catch (Exception e) {
            todayFinishedBills = 0;
        }

        req.setAttribute("totalDrinks", totalDrinks);
        req.setAttribute("totalStaff", totalStaff);
        req.setAttribute("todayRevenue", todayRevenue);
        req.setAttribute("todayBills", todayFinishedBills);

        // ========== Top 5 thức uống bán chạy ==========
        List<BestSellingDrink> top5Drinks = statisticDAO.getTop5BestSellingDrinks(fromDate, toDate);
        req.setAttribute("top5Drinks", top5Drinks);

        // ========== Thống kê doanh thu theo ngày ==========
        List<RevenueByDay> revenueByDay = statisticDAO.getRevenueByDay(fromDate, toDate);

        // Chuẩn bị dữ liệu cho biểu đồ
        List<String> labels = new ArrayList<>();
        List<Long> revenues = new ArrayList<>();
        List<Integer> bills = new ArrayList<>();

        // Tạo map để dễ tra cứu
        java.util.Map<String, RevenueByDay> revenueMap = new java.util.HashMap<>();
        if (revenueByDay != null) {
            for (RevenueByDay rd : revenueByDay) {
                String dateKey = sdf.format(rd.getRevenueDate());
                revenueMap.put(dateKey, rd);
            }
        }

        // Duyệt từng ngày trong khoảng
        Calendar cal = Calendar.getInstance();
        cal.setTime(fromDate);
        while (!cal.getTime().after(toDate)) {
            String dateKey = sdf.format(cal.getTime());
            labels.add(dateKey);

            RevenueByDay rd = revenueMap.get(dateKey);
            if (rd != null) {
                revenues.add(rd.getTotalRevenue());
                bills.add(rd.getTotalBills());
            } else {
                revenues.add(0L);
                bills.add(0);
            }

            cal.add(Calendar.DAY_OF_MONTH, 1);
        }

        // Tính tổng doanh thu và tổng số đơn trong khoảng
        long totalRevenue = 0;
        int totalBillsCount = 0;
        if (revenueByDay != null) {
            for (RevenueByDay rd : revenueByDay) {
                totalRevenue += rd.getTotalRevenue();
                totalBillsCount += rd.getTotalBills();
            }
        }

        req.setAttribute("labels", labels);
        req.setAttribute("revenues", revenues);
        req.setAttribute("bills", bills);
        req.setAttribute("totalRevenue", totalRevenue);
        req.setAttribute("totalBills", totalBillsCount);
        req.setAttribute("fromDate", fromDateStr);
        req.setAttribute("toDate", toDateStr);

        req.getRequestDispatcher("/views/report/report.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }

    private Date getStartOfDay(Date date) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        return cal.getTime();
    }

    private Date getEndOfDay(Date date) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        cal.set(Calendar.HOUR_OF_DAY, 23);
        cal.set(Calendar.MINUTE, 59);
        cal.set(Calendar.SECOND, 59);
        cal.set(Calendar.MILLISECOND, 999);
        return cal.getTime();
    }
}