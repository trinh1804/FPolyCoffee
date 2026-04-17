package com.dao;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.Query;

import com.entity.BestSellingDrink;
import com.entity.RevenueByDay;
import com.util.JpaUtil;

public class StatisticDAO {

    /**
     * Top 5 đồ uống bán chạy nhất trong khoảng thời gian.
     *
     * BUG FIX: Query cũ dùng LEFT JOIN nhưng WHERE b.status = 1 biến nó thành
     * INNER JOIN — các đồ uống chưa có đơn hoàn thành bị loại mất.
     * Fix: chuyển điều kiện status vào mệnh đề ON của JOIN để giữ LEFT JOIN đúng nghĩa.
     */
    public List<BestSellingDrink> getTop5BestSellingDrinks(Date fromDate, Date toDate) {
        EntityManager em = JpaUtil.getEntityManager();
        List<BestSellingDrink> result = new ArrayList<>();
        try {
            String sql =
                "SELECT TOP 5 d.id, d.name, " +
                "  ISNULL(SUM(bd.quantity), 0)    AS total_qty, " +
                "  ISNULL(SUM(bd.total_price), 0) AS total_rev " +
                "FROM DRINK d " +
                "LEFT JOIN BILLDETAIL bd ON d.id = bd.drink_id " +
                "LEFT JOIN BILL b " +
                "       ON bd.bill_id = b.id " +
                "      AND b.status = 1 " +
                "      AND (:from IS NULL OR CAST(b.created_at AS DATE) >= CAST(:from AS DATE)) " +
                "      AND (:to   IS NULL OR CAST(b.created_at AS DATE) <= CAST(:to   AS DATE)) " +
                "WHERE d.status = 1 " +      // chỉ đồ uống đang bán
                "GROUP BY d.id, d.name " +
                "ORDER BY total_qty DESC";

            Query query = em.createNativeQuery(sql);
            query.setParameter("from", fromDate == null ? null : new java.sql.Date(fromDate.getTime()));
            query.setParameter("to",   toDate   == null ? null : new java.sql.Date(toDate.getTime()));

            @SuppressWarnings("unchecked")
            List<Object[]> rows = query.getResultList();
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
     * Doanh thu theo ngày trong khoảng thời gian (chỉ đơn hoàn thành).
     */
    public List<RevenueByDay> getRevenueByDay(Date fromDate, Date toDate) {
        EntityManager em = JpaUtil.getEntityManager();
        List<RevenueByDay> result = new ArrayList<>();
        try {
            String sql =
                "SELECT " +
                "  CAST(b.created_at AS DATE)     AS revenue_date, " +
                "  COUNT(b.id)                    AS total_bills, " +
                "  ISNULL(SUM(b.total_price), 0)  AS total_revenue " +
                "FROM BILL b " +
                "WHERE b.status = 1 " +
                "  AND CAST(b.created_at AS DATE) >= CAST(:from AS DATE) " +
                "  AND CAST(b.created_at AS DATE) <= CAST(:to   AS DATE) " +
                "GROUP BY CAST(b.created_at AS DATE) " +
                "ORDER BY revenue_date";

            Query query = em.createNativeQuery(sql);
            query.setParameter("from", new java.sql.Date(fromDate.getTime()));
            query.setParameter("to",   new java.sql.Date(toDate.getTime()));

            @SuppressWarnings("unchecked")
            List<Object[]> rows = query.getResultList();
            for (Object[] row : rows) {
                RevenueByDay dto = new RevenueByDay();
                dto.setRevenueDate(new Date(((java.sql.Date) row[0]).getTime()));
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
}
