package dao;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import entity.Drink;
import util.JdbcUtil;

public class DrinkDAO implements CrudDAO<Drink, Integer> {

    @Override
    public int create(Drink entity) {
        String sql = "INSERT INTO DRINK(name, price, description, image, status, category_id) VALUES (?,?,?,?,?,?)";
        try {
            return JdbcUtil.executeUpdate(sql,
                    entity.getName(), entity.getPrice(), entity.getDescription(),
                    entity.getImage(), entity.isActive(), entity.getCategoryId());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int update(Drink entity) {
        String sql = "UPDATE DRINK SET name=?, price=?, description=?, image=?, status=?, category_id=? WHERE id=?";
        try {
            return JdbcUtil.executeUpdate(sql,
                    entity.getName(), entity.getPrice(), entity.getDescription(),
                    entity.getImage(), entity.isActive(), entity.getCategoryId(), entity.getId());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int delete(Integer id) {
        String sql = "DELETE FROM DRINK WHERE id=?";
        try {
            return JdbcUtil.executeUpdate(sql, id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** Soft delete - ẩn đồ uống thay vì xóa */
    public int softDelete(Integer id) {
        String sql = "UPDATE DRINK SET status=0 WHERE id=?";
        try {
            return JdbcUtil.executeUpdate(sql, id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public List<Drink> findAll() {
        return findBySql("SELECT * FROM DRINK ORDER BY name");
    }

    /** Chỉ lấy đồ uống đang bán */
    public List<Drink> findAllActive() {
        return findBySql("SELECT * FROM DRINK WHERE status=1 ORDER BY name");
    }

    /** Lấy đồ uống theo danh mục */
    public List<Drink> findByCategoryId(int categoryId) {
        return findBySql("SELECT * FROM DRINK WHERE category_id=? AND status=1", categoryId);
    }

    @Override
    public Drink findById(Integer id) {
        List<Drink> list = findBySql("SELECT * FROM DRINK WHERE id=?", id);
        return list.isEmpty() ? null : list.get(0);
    }

    @Override
    public List<Drink> findBySql(String sql, Object... values) {
        List<Drink> list = new ArrayList<>();
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

    private Drink mapRow(ResultSet rs) throws Exception {
        return new Drink(
                rs.getInt("id"),
                rs.getString("name"),
                rs.getDouble("price"),
                rs.getString("description"),
                rs.getString("image"),
                rs.getBoolean("status"),
                rs.getInt("category_id"));
    }
}
