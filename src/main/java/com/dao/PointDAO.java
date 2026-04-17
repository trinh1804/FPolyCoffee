package com.dao;

import java.util.Date;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.TypedQuery;

import com.entity.PointTransaction;
import com.util.JpaUtil;

public class PointDAO implements CrudDAO<PointTransaction, Integer> {

    /** 10.000 VNĐ = 1 điểm tích lũy */
    public static final double AMOUNT_PER_POINT = 10_000.0;
    /** 1 điểm = 1.000 VNĐ giảm giá */
    public static final double POINT_VALUE = 1_000.0;

    @Override
    public int create(PointTransaction entity) {
        if (entity.getTransactionDate() == null) {
            entity.setTransactionDate(new Date());
        }
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(entity);
            em.getTransaction().commit();
            return 1;
        } catch (Exception e) {
            if (em.getTransaction().isActive())
                em.getTransaction().rollback();
            e.printStackTrace();
            return 0;
        } finally {
            em.close();
        }
    }

    /** Lịch sử giao dịch không cho sửa */
    @Override
    public int update(PointTransaction entity) {
        return 0;
    }

    /** Lịch sử giao dịch không cho xóa */
    @Override
    public int delete(Integer id) {
        return 0;
    }

    @Override
    public List<PointTransaction> findAll() {
        return findBySql("SELECT p FROM PointTransaction p ORDER BY p.transactionDate DESC");
    }

    @Override
    public PointTransaction findById(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.find(PointTransaction.class, id);
        } finally {
            em.close();
        }
    }

    @Override
    public List<PointTransaction> findBySql(String jpql, Object... values) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<PointTransaction> q = em.createQuery(jpql, PointTransaction.class);
            for (int i = 0; i < values.length; i++) {
                q.setParameter(i + 1, values[i]);
            }
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    /** Lịch sử giao dịch điểm của một khách hàng */
    public List<PointTransaction> findByCustomerId(Integer customerId) {
        return findBySql(
                "SELECT p FROM PointTransaction p WHERE p.customerId = ?1 " +
                        "ORDER BY p.transactionDate DESC",
                customerId);
    }

    /** Giao dịch điểm theo hóa đơn */
    public PointTransaction findByBillId(Integer billId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT p FROM PointTransaction p WHERE p.billId = ?1",
                    PointTransaction.class)
                    .setParameter(1, billId)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    /** Tính điểm thưởng dựa trên tổng tiền */
    public int calcBonusPoint(double totalPrice) {
        return (int) (totalPrice / AMOUNT_PER_POINT);
    }

    /**
     * Tích điểm sau khi thanh toán xong.
     * Ghi lịch sử POINT và cộng điểm vào CUSTOMER.
     */
    public int earnPoint(Integer customerId, Integer billId, double totalPrice) {
        int bonus = calcBonusPoint(totalPrice);
        if (bonus <= 0)
            return 0;
        PointTransaction p = new PointTransaction(
                null, bonus, 0, new Date(),
                "Tích điểm hóa đơn #" + billId, customerId, billId);
        int rs = create(p);
        if (rs > 0) {
            new CustomerDAO().addPoint(customerId, bonus);
        }
        return rs;
    }

    /**
     * Sử dụng điểm để giảm giá.
     * Trừ điểm khỏi CUSTOMER và ghi lịch sử.
     * 
     * @return số tiền được giảm giá (VNĐ), 0 nếu không đủ điểm
     */
    public double redeemPoint(Integer customerId, Integer billId, int pointsToUse) {
        int deducted = new CustomerDAO().deductPoint(customerId, pointsToUse);
        if (deducted > 0) {
            double discountAmount = pointsToUse * POINT_VALUE;
            PointTransaction p = new PointTransaction(
                    null, 0, pointsToUse, new Date(),
                    "Dùng " + pointsToUse + " điểm, giảm " + (long) discountAmount + " VNĐ",
                    customerId, billId);
            create(p);
            return discountAmount;
        }
        return 0;
    }
}