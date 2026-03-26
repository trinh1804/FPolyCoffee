package com.util;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

/**
 * Tiện ích JPA – quản lý EntityManagerFactory dưới dạng singleton.
 * EntityManagerFactory rất nặng → chỉ tạo 1 lần khi ứng dụng khởi động.
 * EntityManager nhẹ → tạo mới cho mỗi request / transaction.
 *
 * Cách dùng điển hình trong DAO:
 * 
 * <pre>
 * EntityManager em = JpaUtil.getEntityManager();
 * try {
 *     em.getTransaction().begin();
 *     // ... thao tác DB
 *     em.getTransaction().commit();
 * } catch (Exception e) {
 *     if (em.getTransaction().isActive())
 *         em.getTransaction().rollback();
 *     throw e;
 * } finally {
 *     em.close();
 * }
 * </pre>
 */
public class JpaUtil {

    private static final String PERSISTENCE_UNIT = "FPolyCoffee";

    /**
     * Lazy singleton factory – tạo khi cần lần đầu, tránh khởi tạo khi load class
     * (giúp unit test mock static tốt hơn).
     */
    private static volatile EntityManagerFactory factory;

    private JpaUtil() {
    } // Không cho khởi tạo trực tiếp

    private static EntityManagerFactory getFactory() {
        if (factory == null || !factory.isOpen()) {
            synchronized (JpaUtil.class) {
                if (factory == null || !factory.isOpen()) {
                    factory = Persistence.createEntityManagerFactory(PERSISTENCE_UNIT);
                }
            }
        }
        return factory;
    }

    /**
     * Lấy EntityManager mới cho mỗi thao tác.
     * Người gọi có trách nhiệm gọi {@code em.close()} sau khi xong.
     */
    public static EntityManager getEntityManager() {
        return getFactory().createEntityManager();
    }

    /**
     * Đóng factory khi ứng dụng shutdown (gọi từ ServletContextListener).
     */
    public static void close() {
        if (factory != null && factory.isOpen()) {
            factory.close();
        }
    }
}