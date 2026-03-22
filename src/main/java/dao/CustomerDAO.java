package dao;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import entity.Customer;
import util.JdbcUtil;

public class CustomerDAO implements CrudDAO<Customer, Integer> {

    @Override
    public int create(Customer entity) {
        String sql = "INSERT INTO CUSTOMER(fullname, phone, email, point, status, created_at) VALUES (?,?,?,?,?,?)";
        try {
            return JdbcUtil.executeUpdate(sql,
                    entity.getFullName(), entity.getPhone(), entity.getEmail(),
                    entity.getPoint(), entity.isActive(), new Date());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int update(Customer entity) {
        String sql = "UPDATE CUSTOMER SET fullname=?, phone=?, email=?, status=? WHERE id=?";
        try {
            return JdbcUtil.executeUpdate(sql,
                    entity.getFullName(), entity.getPhone(), entity.getEmail(),
                    entity.isActive(), entity.getId());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int delete(Integer id) {
        return updateStatus(id, false);
    }

    @Override
    public List<Customer> findAll() {
        return findBySql("SELECT * FROM CUSTOMER ORDER BY fullname");
    }

    @Override
    public Customer findById(Integer id) {
        List<Customer> list = findBySql("SELECT * FROM CUSTOMER WHERE id=?", id);
        return list.isEmpty() ? null : list.get(0);
    }

    @Override
    public List<Customer> findBySql(String sql, Object... values) {
        List<Customer> list = new ArrayList<>();
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

    /** Tìm khách hàng theo số điện thoại */
    public Customer findByPhone(String phone) {
        List<Customer> list = findBySql("SELECT * FROM CUSTOMER WHERE phone=?", phone);
        return list.isEmpty() ? null : list.get(0);
    }

    /** Cập nhật điểm tích lũy */
    public int updatePoint(Integer customerId, int point) {
        String sql = "UPDATE CUSTOMER SET point=? WHERE id=?";
        try {
            return JdbcUtil.executeUpdate(sql, point, customerId);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** Thêm điểm */
    public int addPoint(Integer customerId, int bonusPoint) {
        String sql = "UPDATE CUSTOMER SET point = point + ? WHERE id=?";
        try {
            return JdbcUtil.executeUpdate(sql, bonusPoint, customerId);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** Trừ điểm */
    public int deductPoint(Integer customerId, int deductPoint) {
        String sql = "UPDATE CUSTOMER SET point = point - ? WHERE id=? AND point >= ?";
        try {
            return JdbcUtil.executeUpdate(sql, deductPoint, customerId, deductPoint);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int updateStatus(Integer id, boolean active) {
        String sql = "UPDATE CUSTOMER SET status=? WHERE id=?";
        try {
            return JdbcUtil.executeUpdate(sql, active, id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Customer mapRow(ResultSet rs) throws Exception {
        return new Customer(
                rs.getInt("id"),
                rs.getString("fullname"),
                rs.getString("phone"),
                rs.getString("email"),
                rs.getInt("point"),
                rs.getBoolean("status"),
                rs.getDate("created_at"));
    }
}
