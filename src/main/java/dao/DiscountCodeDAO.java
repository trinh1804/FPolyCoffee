package dao;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import entity.DiscountCode;
import util.JdbcUtil;

public class DiscountCodeDAO implements CrudDAO<DiscountCode, Integer> {

    @Override
    public int create(DiscountCode entity) {
        String sql = "INSERT INTO DISCOUNTCODE(code, discount_value, discount_type, start_date, end_date, status, condition_note) "
                + "VALUES (?,?,?,?,?,?,?)";
        try {
            return JdbcUtil.executeUpdate(sql,
                    entity.getCode(), entity.getDiscountValue(), entity.isDiscountType(),
                    entity.getStartDate(), entity.getEndDate(), entity.isActive(),
                    entity.getConditionNote());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int update(DiscountCode entity) {
        String sql = "UPDATE DISCOUNTCODE SET code=?, discount_value=?, discount_type=?, start_date=?, end_date=?, status=?, condition_note=? "
                + "WHERE id=?";
        try {
            return JdbcUtil.executeUpdate(sql,
                    entity.getCode(), entity.getDiscountValue(), entity.isDiscountType(),
                    entity.getStartDate(), entity.getEndDate(), entity.isActive(),
                    entity.getConditionNote(), entity.getId());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int delete(Integer id) {
        String sql = "DELETE FROM DISCOUNTCODE WHERE id=?";
        try {
            return JdbcUtil.executeUpdate(sql, id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public List<DiscountCode> findAll() {
        return findBySql("SELECT * FROM DISCOUNTCODE ORDER BY id DESC");
    }

    @Override
    public DiscountCode findById(Integer id) {
        List<DiscountCode> list = findBySql("SELECT * FROM DISCOUNTCODE WHERE id=?", id);
        return list.isEmpty() ? null : list.get(0);
    }

    /** Tìm theo mã code (còn hiệu lực) */
    public DiscountCode findByCode(String code) {
        String sql = "SELECT * FROM DISCOUNTCODE WHERE code=? AND status=1 AND start_date<=? AND end_date>=?";
        Date today = new Date();
        List<DiscountCode> list = findBySql(sql, code,
                new java.sql.Date(today.getTime()), new java.sql.Date(today.getTime()));
        return list.isEmpty() ? null : list.get(0);
    }

    @Override
    public List<DiscountCode> findBySql(String sql, Object... values) {
        List<DiscountCode> list = new ArrayList<>();
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

    /**
     * Tính số tiền giảm giá dựa vào loại mã và tổng tiền
     * discountType=false → giảm số tiền cố định
     * discountType=true → giảm theo %
     */
    public double calculateDiscount(DiscountCode dc, double totalPrice) {
        if (dc == null)
            return 0;
        if (dc.isDiscountType()) {
            // Giảm theo phần trăm
            return totalPrice * dc.getDiscountValue() / 100.0;
        } else {
            // Giảm cố định
            return Math.min(dc.getDiscountValue(), totalPrice);
        }
    }

    private DiscountCode mapRow(ResultSet rs) throws Exception {
        return new DiscountCode(
                rs.getInt("id"),
                rs.getString("code"),
                rs.getDouble("discount_value"),
                rs.getBoolean("discount_type"),
                rs.getDate("start_date"),
                rs.getDate("end_date"),
                rs.getBoolean("status"),
                rs.getString("condition_note"));
    }
}
