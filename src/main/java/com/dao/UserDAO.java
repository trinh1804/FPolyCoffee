package com.dao;

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.TypedQuery;

import com.entity.User;
import com.util.JpaUtil;

public class UserDAO implements CrudDAO<User, Integer> {

    @Override
    public int create(User entity) {
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
    public int update(User entity) {
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

    /** Soft delete – khóa tài khoản thay vì xóa */
    @Override
    public int delete(Integer id) {
        return updateStatus(id, false);
    }

    @Override
    public List<User> findAll() {
        return findBySql("SELECT u FROM User u");
    }

    @Override
    public User findById(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.find(User.class, id);
        } finally {
            em.close();
        }
    }

    @Override
    public List<User> findBySql(String jpql, Object... values) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<User> q = em.createQuery(jpql, User.class);
            for (int i = 0; i < values.length; i++) {
                q.setParameter(i + 1, values[i]);
            }
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    /** Tìm user đang active theo email */
    public User findByEmail(String email) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT u FROM User u WHERE u.email = ?1 AND u.active = true", User.class)
                    .setParameter(1, email)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    /** Tìm user bất kỳ (kể cả locked) theo email */
    public User findByEmailAny(String email) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT u FROM User u WHERE u.email = ?1", User.class)
                    .setParameter(1, email)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    /** Tìm user theo số điện thoại */
    public User findByPhone(String phone) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT u FROM User u WHERE u.phone = ?1", User.class)
                    .setParameter(1, phone)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    /** Lấy danh sách nhân viên theo role */
    public List<User> findByRoleId(int roleId) {
        return findBySql("SELECT u FROM User u WHERE u.roleId = ?1", roleId);
    }

    /** Cập nhật thông tin cá nhân (fullName, phone) */
    public int updateProfile(User entity) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            int rows = em.createQuery(
                    "UPDATE User u SET u.fullName = ?1, u.phone = ?2 WHERE u.id = ?3")
                    .setParameter(1, entity.getFullName())
                    .setParameter(2, entity.getPhone())
                    .setParameter(3, entity.getId())
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

    /** Đổi mật khẩu */
    public int updatePassword(Integer id, String newPassword) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            int rows = em.createQuery(
                    "UPDATE User u SET u.password = ?1 WHERE u.id = ?2")
                    .setParameter(1, newPassword)
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

    /** Cập nhật trạng thái kích hoạt */
    public int updateStatus(Integer id, boolean active) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            int rows = em.createQuery(
                    "UPDATE User u SET u.active = ?1 WHERE u.id = ?2")
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

    public List<User> searchStaff(String fullName, String email, Boolean active, int page, int pageSize) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            StringBuilder jpql = new StringBuilder("SELECT u FROM User u WHERE u.roleId = 2");

            if (fullName != null && !fullName.trim().isEmpty()) {
                jpql.append(" AND u.fullName LIKE :fullName");
            }
            if (email != null && !email.trim().isEmpty()) {
                jpql.append(" AND u.email LIKE :email");
            }
            if (active != null) {
                jpql.append(" AND u.active = :active");
            }

            jpql.append(" ORDER BY u.id ");

            TypedQuery<User> query = em.createQuery(jpql.toString(), User.class);

            if (fullName != null && !fullName.trim().isEmpty()) {
                query.setParameter("fullName", "%" + fullName.trim() + "%");
            }
            if (email != null && !email.trim().isEmpty()) {
                query.setParameter("email", "%" + email.trim() + "%");
            }
            if (active != null) {
                query.setParameter("active", active);
            }

            int offset = (page - 1) * pageSize;
            query.setFirstResult(offset);
            query.setMaxResults(pageSize);

            return query.getResultList();
        } finally {
            em.close();
        }
    }

    /**
     * Đếm tổng số nhân viên thỏa mãn điều kiện
     */
    public int countSearchStaff(String fullName, String email, Boolean active) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            StringBuilder jpql = new StringBuilder("SELECT COUNT(u) FROM User u WHERE u.roleId = 2");

            if (fullName != null && !fullName.trim().isEmpty()) {
                jpql.append(" AND u.fullName LIKE :fullName");
            }
            if (email != null && !email.trim().isEmpty()) {
                jpql.append(" AND u.email LIKE :email");
            }
            if (active != null) {
                jpql.append(" AND u.active = :active");
            }

            TypedQuery<Long> query = em.createQuery(jpql.toString(), Long.class);

            if (fullName != null && !fullName.trim().isEmpty()) {
                query.setParameter("fullName", "%" + fullName.trim() + "%");
            }
            if (email != null && !email.trim().isEmpty()) {
                query.setParameter("email", "%" + email.trim() + "%");
            }
            if (active != null) {
                query.setParameter("active", active);
            }

            Long count = query.getSingleResult();
            return count != null ? count.intValue() : 0;
        } finally {
            em.close();
        }
    }

    /**
     * Lấy danh sách nhân viên (chỉ roleId = 2)
     */
    public List<User> findAllStaff() {
        return findBySql("SELECT u FROM User u WHERE u.roleId = 2 ORDER BY u.id");
    }

    /**
     * Cập nhật mật khẩu mới cho nhân viên
     */
    public int resetPassword(Integer id, String newPassword) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            int rows = em.createQuery("UPDATE User u SET u.password = ?1 WHERE u.id = ?2")
                    .setParameter(1, newPassword)
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