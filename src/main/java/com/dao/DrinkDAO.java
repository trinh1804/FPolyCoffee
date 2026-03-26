package com.dao;

import java.util.List;

import com.entity.Drink;
import com.util.JpaUtil;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

public class DrinkDAO implements CrudDAO<Drink, Integer> {

    @Override
    public int create(Drink entity) {
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
    public int update(Drink entity) {
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

    /** Xóa vật lý (chỉ dùng khi chưa có bill nào liên quan) */
    @Override
    public int delete(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Drink d = em.find(Drink.class, id);
            if (d != null)
                em.remove(d);
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

    /** Soft delete – ẩn đồ uống thay vì xóa */
    public int softDelete(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            int rows = em.createQuery(
                    "UPDATE Drink d SET d.active = false WHERE d.id = ?1")
                    .setParameter(1, id)
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
    public List<Drink> findAll() {
        return findBySql("SELECT d FROM Drink d ORDER BY d.name");
    }

    /** Chỉ lấy đồ uống đang bán */
    public List<Drink> findAllActive() {
        return findBySql("SELECT d FROM Drink d WHERE d.active = true ORDER BY d.name");
    }

    /** Lấy đồ uống theo danh mục (chỉ active) */
    public List<Drink> findByCategoryId(int categoryId) {
        return findBySql(
                "SELECT d FROM Drink d WHERE d.categoryId = ?1 AND d.active = true",
                categoryId);
    }

    @Override
    public Drink findById(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.find(Drink.class, id);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Drink> findBySql(String jpql, Object... values) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<Drink> q = em.createQuery(jpql, Drink.class);
            for (int i = 0; i < values.length; i++) {
                q.setParameter(i + 1, values[i]);
            }
            return q.getResultList();
        } finally {
            em.close();
        }
    }
}