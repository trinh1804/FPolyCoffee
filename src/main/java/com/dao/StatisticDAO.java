package com.dao;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.entity.BestSellingDrink;
import com.entity.RevenueByDay;
import com.util.JpaUtil;

import jakarta.persistence.EntityManager;

/**
 * StatisticDAO – sử dụng Native Query vì các câu truy vấn tổng hợp
 * dùng hàm đặc thù của SQL Server (TOP, ISNULL) không hỗ trợ tốt trong JPQL.
 */
public class StatisticDAO {

    /**
     * Top 5 đồ uống bán chạy nhất trong khoảng thời gian.
     */
    public List<BestSellingDrink> getTop5BestSellingDrinks(Date fromDate, Date toDate) {
        EntityManager em = JpaUtil.getEntityManager();
        List<BestSellingDrink> result = new ArrayList<>();
        try {
            String sql = "SELECT TOP 5 d.id, d.name, " +
                    "  SUM(bd.quantity) AS total_qty, " +
                    "  SUM(bd.total_price) AS total_rev " +
                    "FROM BILLDETAIL bd " +
                    "INNER JOIN DRINK d ON bd.drink_id = d.id " +
                    "INNER JOIN BILL b ON bd.bill_id = b.id " +
                    "WHERE b.status = 1 " +
                    "  AND (:from IS NULL OR b.created_at >= :from) " +
                    "  AND (:to   IS NULL OR b.created_at <= :to) " +
                    "GROUP BY d.id, d.name " +
                    "ORDER BY total_qty DESC";

            @SuppressWarnings("unchecked")
            List<Object[]> rows = em.createNativeQuery(sql)
                    .setParameter("from", fromDate == null ? null : new java.sql.Date(fromDate.getTime()))
                    .setParameter("to", toDate == null ? null : new java.sql.Date(toDate.getTime()))
                    .getResultList();

            for (Object[] row : rows) {
                BestSellingDrink dto = new BestSellingDrink();
                dto.setDrinkId(((Number) row[0]).intValue());
                dto.setDrinkName((String) row[1]);
                dto.setTotalQuantitySold(((Number) row[2]).intValue());
                dto.setTotalRevenue(((Number) row[3]).longValue());
                result.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }
        return result;
    }

    /**
     * Doanh thu theo ngày trong khoảng thời gian.
     */
    public List<RevenueByDay> getRevenueByDay(Date fromDate, Date toDate) {
        EntityManager em = JpaUtil.getEntityManager();
        List<RevenueByDay> result = new ArrayList<>();
        try {
            String sql = "SELECT created_at, COUNT(id), SUM(total_price) " +
                    "FROM BILL " +
                    "WHERE status = 1 AND created_at BETWEEN :from AND :to " +
                    "GROUP BY created_at " +
                    "ORDER BY created_at";

            @SuppressWarnings("unchecked")
            List<Object[]> rows = em.createNativeQuery(sql)
                    .setParameter("from", new java.sql.Date(fromDate.getTime()))
                    .setParameter("to", new java.sql.Date(toDate.getTime()))
                    .getResultList();

            for (Object[] row : rows) {
                RevenueByDay dto = new RevenueByDay();
                dto.setRevenueDate((Date) row[0]);
                dto.setTotalBills(((Number) row[1]).intValue());
                dto.setTotalRevenue(((Number) row[2]).longValue());
                result.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }
        return result;
    }

    /** Tổng doanh thu theo khoảng ngày */
    public double getTotalRevenue(Date fromDate, Date toDate) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            Object val = em.createNativeQuery(
                    "SELECT ISNULL(SUM(total_price),0) FROM BILL " +
                            "WHERE status=1 AND created_at BETWEEN :from AND :to")
                    .setParameter("from", new java.sql.Date(fromDate.getTime()))
                    .setParameter("to", new java.sql.Date(toDate.getTime()))
                    .getSingleResult();
            return val instanceof Number ? ((Number) val).doubleValue() : 0;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        } finally {
            em.close();
        }
    }

    /** Tổng số hóa đơn theo khoảng ngày */
    public int getTotalBills(Date fromDate, Date toDate) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            Object val = em.createNativeQuery(
                    "SELECT COUNT(id) FROM BILL " +
                            "WHERE status=1 AND created_at BETWEEN :from AND :to")
                    .setParameter("from", new java.sql.Date(fromDate.getTime()))
                    .setParameter("to", new java.sql.Date(toDate.getTime()))
                    .getSingleResult();
            return val instanceof Number ? ((Number) val).intValue() : 0;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        } finally {
            em.close();
        }
    }
}