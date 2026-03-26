package com.dao;

import java.util.Date;
import java.util.List;

import com.entity.Bill;
import com.entity.BillDetail;
import com.util.JpaUtil;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

public class BillDAO implements CrudDAO<Bill, Integer> {

    private final BillDetailDAO billDetailDAO = new BillDetailDAO();

    @Override
    public int create(Bill entity) {
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

    @Override
    public int update(Bill entity) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(entity);
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

    /** Bill không cho xóa */
    @Override
    public int delete(Integer id) {
        return 0;
    }

    @Override
    public List<Bill> findAll() {
        return findBySql("SELECT b FROM Bill b ORDER BY b.createdAt DESC");
    }

    @Override
    public Bill findById(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.find(Bill.class, id);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Bill> findBySql(String jpql, Object... values) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<Bill> q = em.createQuery(jpql, Bill.class);
            for (int i = 0; i < values.length; i++) {
                q.setParameter(i + 1, values[i]);
            }
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    public Bill findByIdAndUserId(Integer billId, Integer userId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            List<Bill> list = em.createQuery(
                    "SELECT b FROM Bill b WHERE b.id = ?1 AND b.userId = ?2", Bill.class)
                    .setParameter(1, billId)
                    .setParameter(2, userId)
                    .getResultList();
            return list.isEmpty() ? null : list.get(0);
        } finally {
            em.close();
        }
    }

    public List<Bill> findByUserId(Integer userId) {
        return findBySql(
                "SELECT b FROM Bill b WHERE b.userId = ?1 " +
                        "ORDER BY CASE b.status WHEN 0 THEN 1 WHEN 1 THEN 2 ELSE 3 END, b.createdAt DESC",
                userId);
    }

    public List<Bill> findWaitingByUserId(Integer userId) {
        return findBySql(
                "SELECT b FROM Bill b WHERE b.userId = ?1 AND b.status = 0", userId);
    }

    public List<Bill> findByDateRange(Date from, Date to) {
        return findBySql(
                "SELECT b FROM Bill b WHERE b.status = 1 " +
                        "AND b.createdAt BETWEEN ?1 AND ?2 ORDER BY b.createdAt DESC",
                from, to);
    }

    /**
     * Tạo bill + danh sách chi tiết trong cùng 1 transaction.
     * 
     * @return id của bill vừa tạo, hoặc 0 nếu thất bại
     */
    public int createWithBillDetails(Bill bill, List<BillDetail> details) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();

            em.persist(bill);
            em.flush(); // flush để bill.id được sinh ra ngay
            int billId = bill.getId();

            for (BillDetail d : details) {
                d.setBillId(billId);
                d.setTotalPrice(d.getQuantity() * d.getUnitPrice());
                em.persist(d);
            }

            em.getTransaction().commit();

            // Tính lại tổng (ngoài transaction tạo để tái dùng logic)
            recalcTotal(billId);
            return billId;
        } catch (Exception e) {
            if (em.getTransaction().isActive())
                em.getTransaction().rollback();
            e.printStackTrace();
            return 0;
        } finally {
            em.close();
        }
    }

    /**
     * Thay đổi trạng thái bill theo quy tắc hợp lệ:
     * WAITING → FINISH | CANCEL
     * FINISH → CANCEL
     */
    public int updateStatus(Integer billId, int newStatus) {
        Bill bill = findById(billId);
        if (bill == null)
            return 0;
        int current = bill.getStatus();
        boolean allowed = (current == Bill.STATUS_WAITING &&
                (newStatus == Bill.STATUS_FINISH || newStatus == Bill.STATUS_CANCEL))
                || (current == Bill.STATUS_FINISH && newStatus == Bill.STATUS_CANCEL);
        if (!allowed)
            return 0;

        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            int rows = em.createQuery(
                    "UPDATE Bill b SET b.status = ?1 WHERE b.id = ?2")
                    .setParameter(1, newStatus)
                    .setParameter(2, billId)
                    .executeUpdate();
            em.getTransaction().commit();
            return rows;
        } catch (Exception e) {
            if (em.getTransaction().isActive())
                em.getTransaction().rollback();
            e.printStackTrace();
            return 0;
        } finally {
            em.close();
        }
    }

    /** Áp mã giảm giá vào bill đang chờ */
    public int applyDiscount(Integer billId, Integer discountId, double discountAmount) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            int rows = em.createQuery(
                    "UPDATE Bill b SET b.discountId = ?1, b.discountAmount = ?2 " +
                            "WHERE b.id = ?3 AND b.status = 0")
                    .setParameter(1, discountId)
                    .setParameter(2, discountAmount)
                    .setParameter(3, billId)
                    .executeUpdate();
            em.getTransaction().commit();
            return rows;
        } catch (Exception e) {
            if (em.getTransaction().isActive())
                em.getTransaction().rollback();
            e.printStackTrace();
            return 0;
        } finally {
            em.close();
        }
    }

    /** Gán khách hàng vào bill (để tích điểm) */
    public int assignCustomer(Integer billId, Integer customerId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            int rows = em.createQuery(
                    "UPDATE Bill b SET b.customerId = ?1 WHERE b.id = ?2 AND b.status = 0")
                    .setParameter(1, customerId)
                    .setParameter(2, billId)
                    .executeUpdate();
            em.getTransaction().commit();
            return rows;
        } catch (Exception e) {
            if (em.getTransaction().isActive())
                em.getTransaction().rollback();
            e.printStackTrace();
            return 0;
        } finally {
            em.close();
        }
    }

    /** Tính lại total_price từ chi tiết hóa đơn */
    public int recalcTotal(Integer billId) {
        List<BillDetail> details = billDetailDAO.findByBillId(billId);
        double subtotal = details.stream().mapToDouble(BillDetail::getTotalPrice).sum();
        Bill bill = findById(billId);
        if (bill == null)
            return 0;
        double finalTotal = Math.max(0, subtotal - bill.getDiscountAmount());

        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            int rows = em.createQuery(
                    "UPDATE Bill b SET b.totalPrice = ?1 WHERE b.id = ?2")
                    .setParameter(1, finalTotal)
                    .setParameter(2, billId)
                    .executeUpdate();
            em.getTransaction().commit();
            return rows;
        } catch (Exception e) {
            if (em.getTransaction().isActive())
                em.getTransaction().rollback();
            e.printStackTrace();
            return 0;
        } finally {
            em.close();
        }
    }

    public double getTotalRevenueByDateRange(Date from, Date to) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            Double result = em.createQuery(
                    "SELECT COALESCE(SUM(b.totalPrice), 0.0) FROM Bill b " +
                            "WHERE b.status = 1 AND b.createdAt BETWEEN ?1 AND ?2",
                    Double.class)
                    .setParameter(1, from)
                    .setParameter(2, to)
                    .getSingleResult();
            return result != null ? result : 0.0;
        } finally {
            em.close();
        }
    }
}