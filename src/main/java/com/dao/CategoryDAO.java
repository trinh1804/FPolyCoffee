package com.dao;

import java.util.Date;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;

import com.entity.Category;
import com.util.JpaUtil;

public class CategoryDAO implements CrudDAO<Category, Integer> {

    @Override
    public int create(Category entity) {
        entity.setCreatedAt(new Date());
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
    public int update(Category entity) {
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

    /** Xóa hẳn khỏi DB (chỉ dùng khi không có drink nào trong danh mục) */
    @Override
    public int delete(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Category cat = em.find(Category.class, id);
            if (cat != null)
                em.remove(cat);
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
    public List<Category> findAll() {
        return findBySql("SELECT c FROM Category c ORDER BY c.id");
    }

    /** Chỉ lấy các danh mục đang hoạt động */
    public List<Category> findAllActive() {
        return findBySql("SELECT c FROM Category c WHERE c.active = true ORDER BY c.name");
    }

    @Override
    public Category findById(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.find(Category.class, id);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Category> findBySql(String jpql, Object... values) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<Category> q = em.createQuery(jpql, Category.class);
            for (int i = 0; i < values.length; i++) {
                q.setParameter(i + 1, values[i]);
            }
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    /** Đếm số đồ uống trong danh mục */
    public int countDrinkInCategory(int categoryId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            Long count = em.createQuery(
                    "SELECT COUNT(d) FROM Drink d WHERE d.categoryId = ?1", Long.class)
                    .setParameter(1, categoryId)
                    .getSingleResult();
            return count != null ? count.intValue() : 0;
        } finally {
            em.close();
        }
    }
}