package com.dao;

import java.util.Date;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;

import com.entity.Bill;
import com.entity.BillDetail;
import com.entity.BillDetailInfo;
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

    /**
     * Lấy danh sách bill có phân trang
     */
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

    /**
     * Đếm tổng số bill
     */
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

    /**
     * Lấy danh sách bill theo trạng thái có phân trang
     */
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

    /**
     * Đếm số bill theo trạng thái
     */
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

    /**
     * Hủy đơn hàng (chỉ hủy được khi đang chờ)
     */
    public int cancelBill(Integer billId) {
        return updateStatus(billId, Bill.STATUS_CANCEL);
    }

    /**
     * Hoàn thành đơn hàng
     */
    public int completeBill(Integer billId) {
        Bill bill = findById(billId);
        if (bill == null)
            return 0;

        // Chỉ hoàn thành được đơn đang chờ (status = 0)
        if (bill.getStatus() != Bill.STATUS_WAITING) {
            return 0;
        }

        return updateStatus(billId, Bill.STATUS_FINISH);
    }

    /**
     * Lấy thông tin chi tiết bill kèm tên nhân viên (dùng native query)
     */
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
     * Xóa cứng các phiếu ĐÃ HỦY có tổng tiền = 0 của một nhân viên.
     * Xóa POINT trước (ON DELETE NO ACTION), BILLDETAIL tự CASCADE.
     */
    public int deleteJunkBillsByUser(Integer userId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.createNativeQuery(
                    "DELETE FROM POINT WHERE bill_id IN (" +
                            "  SELECT id FROM BILL WHERE status = 2 AND total_price = 0 AND user_id = ?1)")
                    .setParameter(1, userId).executeUpdate();
            int rows = em.createQuery(
                    "DELETE FROM Bill b WHERE b.status = 2 AND b.totalPrice = 0 AND b.userId = ?1")
                    .setParameter(1, userId).executeUpdate();
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
     * [Manager] Xóa cứng TẤT CẢ phiếu đã hủy có tổng tiền = 0 (mọi nhân viên).
     */
    public int deleteAllJunkBills() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.createNativeQuery(
                    "DELETE FROM POINT WHERE bill_id IN (" +
                            "  SELECT id FROM BILL WHERE status = 2 AND total_price = 0)")
                    .executeUpdate();
            int rows = em.createQuery(
                    "DELETE FROM Bill b WHERE b.status = 2 AND b.totalPrice = 0")
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

    /** Lấy bills có phân trang, lọc theo status và userId. */
    public List<Bill> findWithFilter(Integer statusFilter, Integer userId, int page, int pageSize) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            StringBuilder jpql = new StringBuilder("SELECT b FROM Bill b WHERE 1=1");
            if (statusFilter != null && statusFilter >= 0 && statusFilter <= 2)
                jpql.append(" AND b.status = :st");
            if (userId != null && userId > 0)
                jpql.append(" AND b.userId = :uid");
            jpql.append(" ORDER BY b.id DESC");
            var q = em.createQuery(jpql.toString(), Bill.class);
            if (statusFilter != null && statusFilter >= 0 && statusFilter <= 2)
                q.setParameter("st", statusFilter);
            if (userId != null && userId > 0)
                q.setParameter("uid", userId);
            q.setFirstResult((page - 1) * pageSize);
            q.setMaxResults(pageSize);
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    /** Đếm bills theo filter. */
    public int countWithFilter(Integer statusFilter, Integer userId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            StringBuilder jpql = new StringBuilder("SELECT COUNT(b) FROM Bill b WHERE 1=1");
            if (statusFilter != null && statusFilter >= 0 && statusFilter <= 2)
                jpql.append(" AND b.status = :st");
            if (userId != null && userId > 0)
                jpql.append(" AND b.userId = :uid");
            var q = em.createQuery(jpql.toString(), Long.class);
            if (statusFilter != null && statusFilter >= 0 && statusFilter <= 2)
                q.setParameter("st", statusFilter);
            if (userId != null && userId > 0)
                q.setParameter("uid", userId);
            Long count = q.getSingleResult();
            return count != null ? count.intValue() : 0;
        } finally {
            em.close();
        }
    }

    /**
     * Thống kê đơn hoàn thành theo từng nhân viên.
     * Trả về Object[]: [userId, staffName, finishCount, totalRevenue]
     */
    @SuppressWarnings("unchecked")
    public List<Object[]> getStaffSalesStats() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String sql = "SELECT b.user_id, u.fullname, " +
                    "  COUNT(CASE WHEN b.status = 1 THEN 1 END) AS finish_count, " +
                    "  ISNULL(SUM(CASE WHEN b.status = 1 THEN b.total_price ELSE 0 END), 0) AS total_rev " +
                    "FROM BILL b LEFT JOIN [USER] u ON b.user_id = u.id " +
                    "WHERE b.user_id IS NOT NULL " +
                    "GROUP BY b.user_id, u.fullname ORDER BY finish_count DESC";
            return (List<Object[]>) em.createNativeQuery(sql).getResultList();
        } finally {
            em.close();
        }
    }

    /**
     * Sinh mã hóa đơn tuần tự: HD001, HD002, ...
     * Lấy mã lớn nhất hiện tại rồi tăng lên 1.
     * Bỏ qua các mã dạng timestamp (HD + 13 chữ số) để tránh overflow.
     */
    public String generateNextCode() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            // Chỉ xét các mã HDxxx có phần số <= 10 ký tự (tránh overflow INT với mã
            // timestamp dài)
            String sql = "SELECT MAX(CAST(SUBSTRING(b.code, 3, LEN(b.code) - 2) AS INT)) " +
                    "FROM Bill b WHERE b.code LIKE 'HD%' " +
                    "AND ISNUMERIC(SUBSTRING(b.code, 3, LEN(b.code) - 2)) = 1 " +
                    "AND LEN(b.code) <= 12";
            Object result = em.createNativeQuery(sql).getSingleResult();
            int nextNum = 1;
            if (result != null) {
                nextNum = ((Number) result).intValue() + 1;
            }
            return String.format("HD%03d", nextNum);
        } catch (Exception e) {
            e.printStackTrace();
            // Fallback: dùng count + 1
            return "HD" + String.format("%03d", countAll() + 1);
        } finally {
            em.close();
        }
    }
}