package com.util;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

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