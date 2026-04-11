package com.dao;

import java.util.Date;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.TypedQuery;

import com.entity.Bill;
import com.entity.BillDetail;
import com.entity.BillDetailInfo;
import com.entity.BillItemInfo;
import com.util.JpaUtil;

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
        return findBySql("SELECT b FROM Bill b ORDER BY b.id DESC");
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
                        "ORDER BY CASE b.status WHEN 0 THEN 1 WHEN 1 THEN 2 ELSE 3 END, b.id DESC",
                userId);
    }

    public List<Bill> findWaitingByUserId(Integer userId) {
        return findBySql(
                "SELECT b FROM Bill b WHERE b.userId = ?1 AND b.status = 0", userId);
    }

    public List<Bill> findByDateRange(Date from, Date to) {
        return findBySql(
                "SELECT b FROM Bill b WHERE b.status = 1 " +
                        "AND b.createdAt BETWEEN ?1 AND ?2 ORDER BY b.id DESC",
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

    /**
     * Gỡ mã giảm giá khỏi bill đang chờ (đặt lại về NULL / 0).
     */
    public int removeDiscount(Integer billId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            int rows = em.createQuery(
                    "UPDATE Bill b SET b.discountId = NULL, b.discountAmount = 0 " +
                            "WHERE b.id = ?1 AND b.status = 0")
                    .setParameter(1, billId)
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

    /** Lấy danh sách bill có phân trang */
    public List<Bill> findAllWithPagination(int page, int pageSize) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery("SELECT b FROM Bill b ORDER BY b.id DESC", Bill.class)
                    .setFirstResult((page - 1) * pageSize)
                    .setMaxResults(pageSize)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    /** Đếm tổng số bill */
    public int countAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            Long count = em.createQuery("SELECT COUNT(b) FROM Bill b", Long.class)
                    .getSingleResult();
            return count != null ? count.intValue() : 0;
        } finally {
            em.close();
        }
    }

    /** Lấy danh sách bill theo trạng thái có phân trang */
    public List<Bill> findByStatusWithPagination(int status, int page, int pageSize) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery("SELECT b FROM Bill b WHERE b.status = ?1 ORDER BY b.id DESC", Bill.class)
                    .setParameter(1, status)
                    .setFirstResult((page - 1) * pageSize)
                    .setMaxResults(pageSize)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    /** Đếm số bill theo trạng thái */
    public int countByStatus(int status) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            Long count = em.createQuery("SELECT COUNT(b) FROM Bill b WHERE b.status = ?1", Long.class)
                    .setParameter(1, status)
                    .getSingleResult();
            return count != null ? count.intValue() : 0;
        } finally {
            em.close();
        }
    }

    /** Hủy đơn hàng (chỉ hủy được khi đang chờ) */
    public int cancelBill(Integer billId) {
        return updateStatus(billId, Bill.STATUS_CANCEL);
    }

    /** Hoàn thành đơn hàng */
    public int completeBill(Integer billId) {
        Bill bill = findById(billId);
        if (bill == null)
            return 0;
        if (bill.getStatus() != Bill.STATUS_WAITING) {
            return 0;
        }
        return updateStatus(billId, Bill.STATUS_FINISH);
    }

    /** Lấy thông tin chi tiết bill kèm tên nhân viên (dùng native query) */
    public BillDetailInfo getBillDetailInfo(Integer billId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String sql = "SELECT b.id, b.code, b.created_at, b.total_price, b.discount_amount, " +
                    "b.payment_method, b.status, b.user_id, u.fullname as staff_name, " +
                    "b.customer_id, c.fullname as customer_name " +
                    "FROM BILL b " +
                    "LEFT JOIN [USER] u ON b.user_id = u.id " +
                    "LEFT JOIN CUSTOMER c ON b.customer_id = c.id " +
                    "WHERE b.id = ?1";

            @SuppressWarnings("unchecked")
            List<Object[]> results = em.createNativeQuery(sql)
                    .setParameter(1, billId)
                    .getResultList();

            if (results.isEmpty())
                return null;

            Object[] row = results.get(0);
            BillDetailInfo info = new BillDetailInfo();
            info.setId(((Number) row[0]).intValue());
            info.setCode((String) row[1]);
            info.setCreatedAt((java.util.Date) row[2]);
            info.setTotalPrice(((Number) row[3]).doubleValue());
            info.setDiscountAmount(((Number) row[4]).doubleValue());
            info.setPaymentMethod(((Boolean) row[5]) != null ? (Boolean) row[5] : false);
            info.setStatus(((Number) row[6]).intValue());
            info.setUserId(row[7] != null ? ((Number) row[7]).intValue() : null);
            info.setStaffName((String) row[8]);
            info.setCustomerId(row[9] != null ? ((Number) row[9]).intValue() : null);
            info.setCustomerName((String) row[10]);

            return info;
        } finally {
            em.close();
        }
    }

    /**
     * Sinh mã hóa đơn tuần tự: HD001, HD002, ...
     *
     * BUG FIX: Dùng BIGINT thay INT để tránh overflow khi phần số > 2 tỷ.
     * Chỉ xét mã HDxxx có phần số từ 1–9 chữ số (LEN tổng 3–11).
     * Các mã dạng timestamp dài hơn bị loại bỏ.
     */
    public String generateNextCode() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            // Dùng BIGINT (không phải INT) để tránh tràn số với mã dài
            // LEN BETWEEN 3 AND 11 = "HD" + 1..9 chữ số
            String sql = "SELECT MAX(CAST(SUBSTRING(b.code, 3, LEN(b.code) - 2) AS BIGINT)) " +
                    "FROM Bill b " +
                    "WHERE b.code LIKE 'HD%' " +
                    "  AND ISNUMERIC(SUBSTRING(b.code, 3, LEN(b.code) - 2)) = 1 " +
                    "  AND LEN(b.code) BETWEEN 3 AND 11 " + // tối đa 9 chữ số → không overflow BIGINT
                    "  AND SUBSTRING(b.code, 3, 1) BETWEEN '0' AND '9'"; // chắc chắn là số nguyên dương

            Object result = em.createNativeQuery(sql).getSingleResult();
            long nextNum = 1;
            if (result != null) {
                nextNum = ((Number) result).longValue() + 1;
            }
            return String.format("HD%03d", nextNum);
        } catch (Exception e) {
            e.printStackTrace();
            // Fallback an toàn: timestamp ngắn gọn
            return "HD" + (System.currentTimeMillis() % 1_000_000);
        } finally {
            em.close();
        }
    }
}