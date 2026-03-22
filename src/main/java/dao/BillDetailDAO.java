package dao;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import entity.BillDetail;
import entity.Drink;
import util.JdbcUtil;

public class BillDetailDAO implements CrudDAO<BillDetail, Integer> {

    private final DrinkDAO drinkDAO = new DrinkDAO();

    @Override
    public int create(BillDetail entity) {
        String sql = "INSERT INTO BILLDETAIL(bill_id, drink_id, quantity, unit_price, total_price) VALUES (?,?,?,?,?)";
        try {
            double tp = entity.getQuantity() * entity.getUnitPrice();
            entity.setTotalPrice(tp);
            return JdbcUtil.executeUpdate(sql,
                    entity.getBillId(), entity.getDrinkId(),
                    entity.getQuantity(), entity.getUnitPrice(), tp);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int update(BillDetail entity) {
        String sql = "UPDATE BILLDETAIL SET quantity=?, unit_price=?, total_price=? WHERE bill_id=? AND drink_id=?";
        try {
            double tp = entity.getQuantity() * entity.getUnitPrice();
            entity.setTotalPrice(tp);
            return JdbcUtil.executeUpdate(sql,
                    entity.getQuantity(), entity.getUnitPrice(), tp,
                    entity.getBillId(), entity.getDrinkId());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int delete(Integer id) {
        return 0;
    }

    public int deleteByBillAndDrink(Integer billId, Integer drinkId) {
        String sql = "DELETE FROM BILLDETAIL WHERE bill_id=? AND drink_id=?";
        try {
            return JdbcUtil.executeUpdate(sql, billId, drinkId);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int deleteByBillId(Integer billId) {
        String sql = "DELETE FROM BILLDETAIL WHERE bill_id=?";
        try {
            return JdbcUtil.executeUpdate(sql, billId);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public List<BillDetail> findAll() {
        return findBySql("SELECT * FROM BILLDETAIL");
    }

    @Override
    public BillDetail findById(Integer id) {
        return null;
    }

    public BillDetail findByBillAndDrink(Integer billId, Integer drinkId) {
        List<BillDetail> list = findBySql(
                "SELECT * FROM BILLDETAIL WHERE bill_id=? AND drink_id=?", billId, drinkId);
        return list.isEmpty() ? null : list.get(0);
    }

    @Override
    public List<BillDetail> findBySql(String sql, Object... values) {
        List<BillDetail> list = new ArrayList<>();
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

    /** Lấy danh sách chi tiết theo bill */
    public List<BillDetail> findByBillId(Integer billId) {
        return findBySql("SELECT * FROM BILLDETAIL WHERE bill_id=?", billId);
    }

    /**
     * Thêm đồ uống vào bill đang chờ.
     * Nếu đã có → tăng số lượng. Nếu chưa có → insert mới.
     */
    public int addDrinkToBill(Integer billId, Integer drinkId) {
        BillDetail existing = findByBillAndDrink(billId, drinkId);
        if (existing != null) {
            return updateQuantity(billId, drinkId, existing.getQuantity() + 1);
        }
        Drink drink = drinkDAO.findById(drinkId);
        if (drink == null)
            return 0;
        BillDetail detail = new BillDetail(billId, drinkId, 1, drink.getPrice(), drink.getPrice());
        return create(detail);
    }

    /**
     * Cập nhật số lượng. Nếu quantity <= 0 → xóa dòng đó.
     */
    public int updateQuantity(Integer billId, Integer drinkId, int quantity) {
        if (quantity <= 0) {
            return deleteByBillAndDrink(billId, drinkId);
        }
        BillDetail existing = findByBillAndDrink(billId, drinkId);
        if (existing == null)
            return 0;
        existing.setQuantity(quantity);
        return update(existing);
    }

    private BillDetail mapRow(ResultSet rs) throws Exception {
        return new BillDetail(
                rs.getInt("bill_id"),
                rs.getInt("drink_id"),
                rs.getInt("quantity"),
                rs.getDouble("unit_price"),
                rs.getDouble("total_price"));
    }
}
