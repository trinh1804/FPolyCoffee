package dao;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import entity.User;
import util.JdbcUtil;

public class UserDAO implements CrudDAO<User, Integer> {

    @Override
    public int create(User entity) {
        String sql = "INSERT INTO [USER](fullname, email, phone, password, status, role_id) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try {
            return JdbcUtil.executeUpdate(sql,
                    entity.getFullName(), entity.getEmail(), entity.getPhone(),
                    entity.getPassword(), entity.isActive(), entity.getRoleId());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int update(User entity) {
        String sql = "UPDATE [USER] SET fullname=?, email=?, phone=?, password=?, status=?, role_id=? "
                + "WHERE id=?";
        try {
            return JdbcUtil.executeUpdate(sql,
                    entity.getFullName(), entity.getEmail(), entity.getPhone(),
                    entity.getPassword(), entity.isActive(), entity.getRoleId(),
                    entity.getId());
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
    public List<User> findAll() {
        return findBySql("SELECT * FROM [USER]");
    }

    @Override
    public User findById(Integer id) {
        List<User> list = findBySql("SELECT * FROM [USER] WHERE id=?", id);
        return list.isEmpty() ? null : list.get(0);
    }

    @Override
    public List<User> findBySql(String sql, Object... values) {
        List<User> list = new ArrayList<>();
        try {
            ResultSet rs = JdbcUtil.executeQuery(sql, values);
            while (rs.next()) {
                User u = mapRow(rs);
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Tìm user theo email */
    public User findByEmail(String email) {
        List<User> list = findBySql("SELECT * FROM [USER] WHERE email=? AND status=1", email);
        return list.isEmpty() ? null : list.get(0);
    }

    /** Tìm user theo email */
    public User findByEmailAny(String email) {
        List<User> list = findBySql("SELECT * FROM [USER] WHERE email=?", email);
        return list.isEmpty() ? null : list.get(0);
    }

    /** Tìm user theo số điện thoại */
    public User findByPhone(String phone) {
        List<User> list = findBySql("SELECT * FROM [USER] WHERE phone=?", phone);
        return list.isEmpty() ? null : list.get(0);
    }

    /** Lấy danh sách nhân viên theo role */
    public List<User> findByRoleId(int roleId) {
        return findBySql("SELECT * FROM [USER] WHERE role_id=?", roleId);
    }

    /** Cập nhật thông tin cá nhân */
    public int updateProfile(User entity) {
        String sql = "UPDATE [USER] SET fullname=?, phone=? WHERE id=?";
        try {
            return JdbcUtil.executeUpdate(sql, entity.getFullName(), entity.getPhone(), entity.getId());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** Đổi mật khẩu */
    public int updatePassword(Integer id, String newPassword) {
        String sql = "UPDATE [USER] SET password=? WHERE id=?";
        try {
            return JdbcUtil.executeUpdate(sql, newPassword, id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** Cập nhật trạng thái kích hoạt */
    public int updateStatus(Integer id, boolean active) {
        String sql = "UPDATE [USER] SET status=? WHERE id=?";
        try {
            return JdbcUtil.executeUpdate(sql, active, id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ---- Helper ----
    private User mapRow(ResultSet rs) throws Exception {
        return new User(
                rs.getInt("id"),
                rs.getString("fullname"),
                rs.getString("email"),
                rs.getString("phone"),
                rs.getString("password"),
                rs.getBoolean("status"),
                rs.getInt("role_id"));
    }
}
