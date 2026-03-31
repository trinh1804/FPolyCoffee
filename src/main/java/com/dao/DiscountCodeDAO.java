package com.dao;

import java.util.Date;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.TypedQuery;

import com.entity.DiscountCode;
import com.util.JpaUtil;

public class DiscountCodeDAO implements CrudDAO<DiscountCode, Integer> {

    @Override
    public int create(DiscountCode entity) {
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
    public int update(DiscountCode entity) {
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

    @Override
    public int delete(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            DiscountCode dc = em.find(DiscountCode.class, id);
            if (dc != null)
                em.remove(dc);
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
    public List<DiscountCode> findAll() {
        return findBySql("SELECT d FROM DiscountCode d ORDER BY d.id DESC");
    }

    @Override
    public DiscountCode findById(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.find(DiscountCode.class, id);
        } finally {
            em.close();
        }
    }

    /**
     * Tìm mã giảm giá còn hiệu lực theo code.
     * Điều kiện: active=true, ngày hôm nay nằm trong [startDate, endDate].
     */
    public DiscountCode findByCode(String code) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            Date today = new Date();
            return em.createQuery(
                    "SELECT d FROM DiscountCode d " +
                            "WHERE d.code = ?1 AND d.active = true " +
                            "  AND d.startDate <= ?2 AND d.endDate >= ?3",
                    DiscountCode.class)
                    .setParameter(1, code)
                    .setParameter(2, today)
                    .setParameter(3, today)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    @Override
    public List<DiscountCode> findBySql(String jpql, Object... values) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<DiscountCode> q = em.createQuery(jpql, DiscountCode.class);
            for (int i = 0; i < values.length; i++) {
                q.setParameter(i + 1, values[i]);
            }
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    /**
     * Tính số tiền giảm giá dựa vào loại mã và tổng tiền.
     * discountType=false → giảm số tiền cố định
     * discountType=true → giảm theo %
     */
    public double calculateDiscount(DiscountCode dc, double totalPrice) {
        if (dc == null)
            return 0;
        if (dc.isDiscountType()) {
            return totalPrice * dc.getDiscountValue() / 100.0;
        } else {
            return Math.min(dc.getDiscountValue(), totalPrice);
        }
    }
}