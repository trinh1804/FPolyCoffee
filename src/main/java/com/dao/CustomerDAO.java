package com.dao;

import java.util.Date;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.TypedQuery;

import com.entity.Customer;
import com.util.JpaUtil;

public class CustomerDAO implements CrudDAO<Customer, Integer> {

    @Override
    public int create(Customer entity) {
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
    public int update(Customer entity) {
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

    /** Soft delete – ẩn khách hàng thay vì xóa */
    @Override
    public int delete(Integer id) {
        return updateStatus(id, false);
    }

    @Override
    public List<Customer> findAll() {
        return findBySql("SELECT c FROM Customer c ORDER BY c.fullName");
    }

    @Override
    public Customer findById(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.find(Customer.class, id);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Customer> findBySql(String jpql, Object... values) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<Customer> q = em.createQuery(jpql, Customer.class);
            for (int i = 0; i < values.length; i++) {
                q.setParameter(i + 1, values[i]);
            }
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    /** Tìm khách hàng theo số điện thoại */
    public Customer findByPhone(String phone) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT c FROM Customer c WHERE c.phone = ?1", Customer.class)
                    .setParameter(1, phone)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    /** Cập nhật điểm tích lũy (ghi đè toàn bộ) */
    public int updatePoint(Integer customerId, int point) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            int rows = em.createQuery(
                    "UPDATE Customer c SET c.point = ?1 WHERE c.id = ?2")
                    .setParameter(1, point)
                    .setParameter(2, customerId)
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

    /** Cộng điểm */
    public int addPoint(Integer customerId, int bonusPoint) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            int rows = em.createQuery(
                    "UPDATE Customer c SET c.point = c.point + ?1 WHERE c.id = ?2")
                    .setParameter(1, bonusPoint)
                    .setParameter(2, customerId)
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

    /**
     * Trừ điểm – chỉ trừ khi còn đủ điểm.
     * 
     * @return số row cập nhật (0 = không đủ điểm hoặc lỗi)
     */
    public int deductPoint(Integer customerId, int deductPoint) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            int rows = em.createQuery(
                    "UPDATE Customer c SET c.point = c.point - ?1 " +
                            "WHERE c.id = ?2 AND c.point >= ?3")
                    .setParameter(1, deductPoint)
                    .setParameter(2, customerId)
                    .setParameter(3, deductPoint)
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

    /** Cập nhật trạng thái active */
    public int updateStatus(Integer id, boolean active) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            int rows = em.createQuery(
                    "UPDATE Customer c SET c.active = ?1 WHERE c.id = ?2")
                    .setParameter(1, active)
                    .setParameter(2, id)
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
}