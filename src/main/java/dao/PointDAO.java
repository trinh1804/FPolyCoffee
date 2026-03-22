package dao;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import entity.PointTransaction;
import util.JdbcUtil;

public class PointDAO implements CrudDAO<PointTransaction, Integer> {

    /** 10,000 VNĐ = 1 điểm tích lũy */
    public static final double AMOUNT_PER_POINT = 10_000.0;
    /** 1 điểm = 1,000 VNĐ giảm giá */
    public static final double POINT_VALUE = 1_000.0;

    @Override
    public int create(PointTransaction entity) {
        String sql = "INSERT INTO POINT(bonus_point, deduct_point, transaction_date, note, customer_id, bill_id) "
                + "VALUES (?,?,?,?,?,?)";
        try {
            return JdbcUtil.executeUpdate(sql,
                    entity.getBonusPoint(), entity.getDeductPoint(),
                    entity.getTransactionDate() != null ? entity.getTransactionDate() : new Date(),
                    entity.getNote(), entity.getCustomerId(), entity.getBillId());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int update(PointTransaction entity) {
        return 0;
    } // Lịch sử không chỉnh sửa

    @Override
    public int delete(Integer id) {
        return 0;
    } // Không xóa lịch sử

    @Override
    public List<PointTransaction> findAll() {
        return findBySql("SELECT * FROM POINT ORDER BY transaction_date DESC");
    }

    @Override
    public PointTransaction findById(Integer id) {
        List<PointTransaction> list = findBySql("SELECT * FROM POINT WHERE id=?", id);
        return list.isEmpty() ? null : list.get(0);
    }

    @Override
    public List<PointTransaction> findBySql(String sql, Object... values) {
        List<PointTransaction> list = new ArrayList<>();
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

    /** Lịch sử giao dịch điểm của một khách hàng */
    public List<PointTransaction> findByCustomerId(Integer customerId) {
        return findBySql(
                "SELECT * FROM POINT WHERE customer_id=? ORDER BY transaction_date DESC", customerId);
    }

    /** Giao dịch điểm theo hóa đơn */
    public PointTransaction findByBillId(Integer billId) {
        List<PointTransaction> list = findBySql("SELECT * FROM POINT WHERE bill_id=?", billId);
        return list.isEmpty() ? null : list.get(0);
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
        PointTransaction p = new PointTransaction(null, bonus, 0, new Date(),
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
     * @return số tiền được giảm giá (VNĐ)
     */
    public double redeemPoint(Integer customerId, Integer billId, int pointsToUse) {
        int deducted = new CustomerDAO().deductPoint(customerId, pointsToUse);
        if (deducted > 0) {
            double discountAmount = pointsToUse * POINT_VALUE;
            PointTransaction p = new PointTransaction(null, 0, pointsToUse, new Date(),
                    "Dùng " + pointsToUse + " điểm, giảm " + (long) discountAmount + " VNĐ",
                    customerId, billId);
            create(p);
            return discountAmount;
        }
        return 0;
    }

    private PointTransaction mapRow(ResultSet rs) throws Exception {
        return new PointTransaction(
                rs.getInt("id"),
                rs.getInt("bonus_point"),
                rs.getInt("deduct_point"),
                rs.getDate("transaction_date"),
                rs.getString("note"),
                rs.getInt("customer_id"),
                rs.getInt("bill_id"));
    }
}
