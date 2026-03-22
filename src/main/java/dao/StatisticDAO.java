package dao;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import entity.BestSellingDrink;
import entity.RevenueByDay;
import util.JdbcUtil;

public class StatisticDAO {

    /**
     * Top 5 đồ uống bán chạy nhất trong khoảng thời gian.
     */
    public List<BestSellingDrink> getTop5BestSellingDrinks(Date fromDate, Date toDate) {
        List<BestSellingDrink> result = new ArrayList<>();
        String sql = "SELECT TOP 5 d.id AS drink_id, d.name AS drink_name, " +
                "  SUM(bd.quantity) AS total_quantity_sold, " +
                "  SUM(bd.total_price) AS total_revenue " +
                "FROM BILLDETAIL bd " +
                "INNER JOIN DRINK d ON bd.drink_id = d.id " +
                "INNER JOIN BILL b ON bd.bill_id = b.id " +
                "WHERE b.status = 1 " +
                "  AND (? IS NULL OR b.created_at >= ?) " +
                "  AND (? IS NULL OR b.created_at <= ?) " +
                "GROUP BY d.id, d.name " +
                "ORDER BY total_quantity_sold DESC";

        java.sql.Date from = fromDate == null ? null : new java.sql.Date(fromDate.getTime());
        java.sql.Date to = toDate == null ? null : new java.sql.Date(toDate.getTime());

        try {
            ResultSet rs = JdbcUtil.executeQuery(sql, from, from, to, to);
            while (rs.next()) {
                BestSellingDrink dto = new BestSellingDrink();
                dto.setDrinkId(rs.getInt("drink_id"));
                dto.setDrinkName(rs.getString("drink_name"));
                dto.setTotalQuantitySold(rs.getInt("total_quantity_sold"));
                dto.setTotalRevenue(rs.getLong("total_revenue"));
                result.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    /**
     * Doanh thu theo ngày trong khoảng thời gian.
     */
    public List<RevenueByDay> getRevenueByDay(Date fromDate, Date toDate) {
        List<RevenueByDay> result = new ArrayList<>();
        String sql = "SELECT created_at AS revenue_date, " +
                "  COUNT(id) AS total_bills, " +
                "  SUM(total_price) AS total_revenue " +
                "FROM BILL " +
                "WHERE status = 1 AND created_at BETWEEN ? AND ? " +
                "GROUP BY created_at " +
                "ORDER BY revenue_date";

        java.sql.Date from = fromDate == null ? null : new java.sql.Date(fromDate.getTime());
        java.sql.Date to = toDate == null ? null : new java.sql.Date(toDate.getTime());

        try {
            ResultSet rs = JdbcUtil.executeQuery(sql, from, to);
            while (rs.next()) {
                RevenueByDay dto = new RevenueByDay();
                dto.setRevenueDate(rs.getDate("revenue_date"));
                dto.setTotalBills(rs.getInt("total_bills"));
                dto.setTotalRevenue(rs.getLong("total_revenue"));
                result.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    /** Tổng doanh thu theo khoảng ngày */
    public double getTotalRevenue(Date fromDate, Date toDate) {
        String sql = "SELECT ISNULL(SUM(total_price),0) AS total FROM BILL WHERE status=1 AND created_at BETWEEN ? AND ?";
        java.sql.Date from = fromDate == null ? null : new java.sql.Date(fromDate.getTime());
        java.sql.Date to = toDate == null ? null : new java.sql.Date(toDate.getTime());
        try {
            ResultSet rs = JdbcUtil.executeQuery(sql, from, to);
            if (rs.next())
                return rs.getDouble("total");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** Tổng số hóa đơn theo khoảng ngày */
    public int getTotalBills(Date fromDate, Date toDate) {
        String sql = "SELECT COUNT(id) AS cnt FROM BILL WHERE status=1 AND created_at BETWEEN ? AND ?";
        java.sql.Date from = fromDate == null ? null : new java.sql.Date(fromDate.getTime());
        java.sql.Date to = toDate == null ? null : new java.sql.Date(toDate.getTime());
        try {
            ResultSet rs = JdbcUtil.executeQuery(sql, from, to);
            if (rs.next())
                return rs.getInt("cnt");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
