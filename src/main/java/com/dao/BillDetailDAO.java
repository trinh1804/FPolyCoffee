package com.dao;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;

import com.entity.BillDetail;
import com.entity.BillDetailId;
import com.entity.BillItemInfo;
import com.entity.Drink;
import com.util.JpaUtil;

public class BillDetailDAO implements CrudDAO<BillDetail, Integer> {

    private final DrinkDAO drinkDAO = new DrinkDAO();

    @Override
    public int create(BillDetail entity) {
        // Tính total_price trước khi lưu
        entity.setTotalPrice(entity.getQuantity() * entity.getUnitPrice());
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
    public int update(BillDetail entity) {
        entity.setTotalPrice(entity.getQuantity() * entity.getUnitPrice());
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

    /** Không hỗ trợ xóa theo single int id (dùng deleteByBillAndDrink) */
    @Override
    public int delete(Integer id) {
        return 0;
    }

    public int deleteByBillAndDrink(Integer billId, Integer drinkId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            int rows = em.createQuery(
                    "DELETE FROM BillDetail bd WHERE bd.id.billId = ?1 AND bd.id.drinkId = ?2")
                    .setParameter(1, billId)
                    .setParameter(2, drinkId)
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

    public int deleteByBillId(Integer billId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            int rows = em.createQuery(
                    "DELETE FROM BillDetail bd WHERE bd.id.billId = ?1")
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

    @Override
    public List<BillDetail> findAll() {
        return findBySql("SELECT bd FROM BillDetail bd");
    }

    /** Không dùng – composite key */
    @Override
    public BillDetail findById(Integer id) {
        return null;
    }

    public BillDetail findByBillAndDrink(Integer billId, Integer drinkId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.find(BillDetail.class, new BillDetailId(billId, drinkId));
        } finally {
            em.close();
        }
    }

    @Override
    public List<BillDetail> findBySql(String jpql, Object... values) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<BillDetail> q = em.createQuery(jpql, BillDetail.class);
            for (int i = 0; i < values.length; i++) {
                q.setParameter(i + 1, values[i]);
            }
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    /** Lấy danh sách chi tiết theo bill */
    public List<BillDetail> findByBillId(Integer billId) {
        return findBySql("SELECT bd FROM BillDetail bd WHERE bd.id.billId = ?1", billId);
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

    /**
     * Lấy danh sách chi tiết bill kèm tên đồ uống
     */
    public List<BillItemInfo> getBillItemsWithDrinkName(Integer billId) {
        EntityManager em = JpaUtil.getEntityManager();
        List<BillItemInfo> result = new ArrayList<>();
        try {
            String sql = "SELECT bd.drink_id, d.name, bd.quantity, bd.unit_price, bd.total_price " +
                    "FROM BILLDETAIL bd " +
                    "INNER JOIN DRINK d ON bd.drink_id = d.id " +
                    "WHERE bd.bill_id = ?1";

            @SuppressWarnings("unchecked")
            List<Object[]> rows = em.createNativeQuery(sql)
                    .setParameter(1, billId)
                    .getResultList();

            for (Object[] row : rows) {
                BillItemInfo item = new BillItemInfo();
                item.setDrinkId(((Number) row[0]).intValue());
                item.setDrinkName((String) row[1]);
                item.setQuantity(((Number) row[2]).intValue());
                item.setUnitPrice(((Number) row[3]).doubleValue());
                item.setTotalPrice(((Number) row[4]).doubleValue());
                result.add(item);
            }
            return result;
        } finally {
            em.close();
        }
    }
}