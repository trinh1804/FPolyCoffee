package dao;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import entity.Category;
import util.JdbcUtil;

public class CategoryDAO implements CrudDAO<Category, Integer> {

    @Override
    public int create(Category entity) {
        String sql = "INSERT INTO CATEGORY(name, description, image, status, created_at) VALUES (?,?,?,?,?)";
        try {
            return JdbcUtil.executeUpdate(sql,
                    entity.getName(), entity.getDescription(), entity.getImage(),
                    entity.isActive(), new Date());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int update(Category entity) {
        String sql = "UPDATE CATEGORY SET name=?, description=?, image=?, status=? WHERE id=?";
        try {
            return JdbcUtil.executeUpdate(sql,
                    entity.getName(), entity.getDescription(), entity.getImage(),
                    entity.isActive(), entity.getId());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int delete(Integer id) {
        String sql = "DELETE FROM CATEGORY WHERE id=?";
        try {
            return JdbcUtil.executeUpdate(sql, id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public List<Category> findAll() {
        return findBySql("SELECT * FROM CATEGORY ORDER BY id");
    }

    /** Chỉ lấy các danh mục đang hoạt động */
    public List<Category> findAllActive() {
        return findBySql("SELECT * FROM CATEGORY WHERE status=1 ORDER BY name");
    }

    @Override
    public Category findById(Integer id) {
        List<Category> list = findBySql("SELECT * FROM CATEGORY WHERE id=?", id);
        return list.isEmpty() ? null : list.get(0);
    }

    @Override
    public List<Category> findBySql(String sql, Object... values) {
        List<Category> list = new ArrayList<>();
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

    /** Đếm số đồ uống trong danh mục */
    public int countDrinkInCategory(int categoryId) {
        String sql = "SELECT COUNT(id) AS cnt FROM DRINK WHERE category_id=?";
        try {
            ResultSet rs = JdbcUtil.executeQuery(sql, categoryId);
            if (rs.next())
                return rs.getInt("cnt");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Category mapRow(ResultSet rs) throws Exception {
        return new Category(
                rs.getInt("id"),
                rs.getString("name"),
                rs.getString("description"),
                rs.getString("image"),
                rs.getBoolean("status"),
                rs.getDate("created_at"));
    }
}
