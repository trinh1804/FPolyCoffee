package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import entity.Bill;
import entity.BillDetail;
import util.JdbcUtil;

public class BillDAO implements CrudDAO<Bill, Integer> {

    private final BillDetailDAO billDetailDAO = new BillDetailDAO();

    @Override
    public int create(Bill entity) {
        String sql = "INSERT INTO BILL(created_at, total_price, discount_amount, payment_method, status, code, user_id, customer_id, discount_id) "
                + "VALUES (?,?,?,?,?,?,?,?,?)";
        try {
            return JdbcUtil.executeUpdate(sql,
                    entity.getCreatedAt(), entity.getTotalPrice(), entity.getDiscountAmount(),
                    entity.isPaymentMethod(), entity.getStatus(), entity.getCode(),
                    entity.getUserId(), entity.getCustomerId(), entity.getDiscountId());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int update(Bill entity) {
        String sql = "UPDATE BILL SET total_price=?, discount_amount=?, payment_method=?, status=?, customer_id=?, discount_id=? WHERE id=?";
        try {
            return JdbcUtil.executeUpdate(sql,
                    entity.getTotalPrice(), entity.getDiscountAmount(),
                    entity.isPaymentMethod(), entity.getStatus(),
                    entity.getCustomerId(), entity.getDiscountId(), entity.getId());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int delete(Integer id) {
        return 0;
    }

    @Override
    public List<Bill> findAll() {
        return findBySql("SELECT * FROM BILL ORDER BY created_at DESC");
    }

    @Override
    public Bill findById(Integer id) {
        List<Bill> list = findBySql("SELECT * FROM BILL WHERE id=?", id);
        return list.isEmpty() ? null : list.get(0);
    }

    @Override
    public List<Bill> findBySql(String sql, Object... values) {
        List<Bill> list = new ArrayList<>();
        try {
            ResultSet rs = JdbcUtil.executeQuery(sql, values);
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Bill findByIdAndUserId(Integer billId, Integer userId) {
        List<Bill> list = findBySql("SELECT * FROM BILL WHERE id=? AND user_id=?", billId, userId);
        return list.isEmpty() ? null : list.get(0);
    }

    public List<Bill> findByUserId(Integer userId) {
        String sql = "SELECT * FROM BILL WHERE user_id=? "
                + "ORDER BY CASE status WHEN 0 THEN 1 WHEN 1 THEN 2 WHEN 2 THEN 3 END, created_at DESC";
        return findBySql(sql, userId);
    }

    public List<Bill> findWaitingByUserId(Integer userId) {
        return findBySql("SELECT * FROM BILL WHERE user_id=? AND status=0", userId);
    }

    public List<Bill> findByDateRange(Date from, Date to) {
        return findBySql(
                "SELECT * FROM BILL WHERE status=1 AND created_at BETWEEN ? AND ? ORDER BY created_at DESC",
                new java.sql.Date(from.getTime()), new java.sql.Date(to.getTime()));
    }

    public int createWithBillDetails(Bill bill, List<BillDetail> details) {
        String sql = "INSERT INTO BILL(created_at, total_price, discount_amount, payment_method, status, code, user_id, customer_id, discount_id) "
                + "VALUES (?,?,?,?,?,?,?,?,?)";
        try {
            PreparedStatement stmt = JdbcUtil.createPreStmt(sql,
                    bill.getCreatedAt(), bill.getTotalPrice(), bill.getDiscountAmount(),
                    bill.isPaymentMethod(), bill.getStatus(), bill.getCode(),
                    bill.getUserId(), bill.getCustomerId(), bill.getDiscountId());
            int rs = stmt.executeUpdate();
            if (rs > 0) {
                ResultSet keys = stmt.getGeneratedKeys();
                if (keys.next()) {
                    int billId = keys.getInt(1);
                    for (BillDetail d : details) {
                        d.setBillId(billId);
                        billDetailDAO.create(d);
                    }
                    recalcTotal(billId);
                    return billId;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int updateStatus(Integer billId, int newStatus) {
        Bill bill = findById(billId);
        if (bill == null)
            return 0;
        int current = bill.getStatus();
        boolean allowed = (current == Bill.STATUS_WAITING
                && (newStatus == Bill.STATUS_FINISH || newStatus == Bill.STATUS_CANCEL))
                || (current == Bill.STATUS_FINISH && newStatus == Bill.STATUS_CANCEL);
        if (!allowed)
            return 0;
        String sql = "UPDATE BILL SET status=? WHERE id=?";
        try {
            return JdbcUtil.executeUpdate(sql, newStatus, billId);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** Áp mã giảm giá vào bill */
    public int applyDiscount(Integer billId, Integer discountId, double discountAmount) {
        String sql = "UPDATE BILL SET discount_id=?, discount_amount=? WHERE id=? AND status=0";
        try {
            return JdbcUtil.executeUpdate(sql, discountId, discountAmount, billId);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** Gán khách hàng vào bill (để tích điểm) */
    public int assignCustomer(Integer billId, Integer customerId) {
        String sql = "UPDATE BILL SET customer_id=? WHERE id=? AND status=0";
        try {
            return JdbcUtil.executeUpdate(sql, customerId, billId);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** Tính lại total_price từ chi tiết hóa đơn */
    public int recalcTotal(Integer billId) {
        List<BillDetail> details = billDetailDAO.findByBillId(billId);
        double total = details.stream().mapToDouble(BillDetail::getTotalPrice).sum();
        Bill bill = findById(billId);
        double finalTotal = Math.max(0, total - (bill != null ? bill.getDiscountAmount() : 0));
        String sql = "UPDATE BILL SET total_price=? WHERE id=?";
        try {
            return JdbcUtil.executeUpdate(sql, finalTotal, billId);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public double getTotalRevenueByDateRange(Date from, Date to) {
        String sql = "SELECT ISNULL(SUM(total_price),0) AS rev FROM BILL WHERE status=1 AND created_at BETWEEN ? AND ?";
        try {
            ResultSet rs = JdbcUtil.executeQuery(sql,
                    new java.sql.Date(from.getTime()), new java.sql.Date(to.getTime()));
            if (rs.next())
                return rs.getDouble("rev");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Bill mapRow(ResultSet rs) throws Exception {
        Bill b = new Bill();
        b.setId(rs.getInt("id"));
        b.setCreatedAt(rs.getDate("created_at"));
        b.setTotalPrice(rs.getDouble("total_price"));
        b.setDiscountAmount(rs.getDouble("discount_amount"));
        b.setPaymentMethod(rs.getBoolean("payment_method"));
        b.setStatus(rs.getInt("status"));
        b.setCode(rs.getString("code"));
        int uid = rs.getInt("user_id");
        b.setUserId(rs.wasNull() ? null : uid);
        int cid = rs.getInt("customer_id");
        b.setCustomerId(rs.wasNull() ? null : cid);
        int did = rs.getInt("discount_id");
        b.setDiscountId(rs.wasNull() ? null : did);
        return b;
    }
}
