package com.dao;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockStatic;
import static org.mockito.Mockito.when;

import java.sql.Date;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.persistence.Query;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;
import org.mockito.MockedStatic;

import com.entity.BestSellingDrink;
import com.entity.RevenueByDay;
import com.util.JpaUtil;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class StatisticDAOTest {

    private StatisticDAO statisticDAO;
    private EntityManager mockEm;
    private EntityTransaction mockTransaction;
    private java.util.Date fromDate;
    private java.util.Date toDate;

    @BeforeEach
    void setUp() {
        statisticDAO = new StatisticDAO();
        mockEm = mock(EntityManager.class);
        mockTransaction = mock(EntityTransaction.class);

        when(mockEm.getTransaction()).thenReturn(mockTransaction);
        when(mockTransaction.isActive()).thenReturn(true);

        fromDate = new Date(System.currentTimeMillis() - 30L * 24 * 60 * 60 * 1000);
        toDate = new Date(System.currentTimeMillis());
    }

    @Test
    @Order(1)
    @DisplayName("getTop5BestSellingDrinks() - Trả về danh sách đúng")
    void testTop5BestSelling_ReturnsList() throws Exception {
        Query mockQuery = mock(Query.class);
        List<Object[]> resultList = List.of(
                new Object[] { 1, "Cafe Den", 100, 2500000L },
                new Object[] { 2, "Tra Xanh", 80, 1600000L });

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createNativeQuery(anyString())).thenReturn(mockQuery);
            when(mockQuery.setParameter(anyString(), any())).thenReturn(mockQuery);
            when(mockQuery.getResultList()).thenReturn(resultList);

            List<BestSellingDrink> list = statisticDAO.getTop5BestSellingDrinks(fromDate, toDate);
            assertEquals(2, list.size());
            assertEquals("Cafe Den", list.get(0).getDrinkName());
            assertEquals(100, list.get(0).getTotalQuantitySold());
        }
    }

    @Test
    @Order(2)
    @DisplayName("getTop5BestSellingDrinks() - Không có dữ liệu trả về rỗng")
    void testTop5BestSelling_Empty() throws Exception {
        Query mockQuery = mock(Query.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createNativeQuery(anyString())).thenReturn(mockQuery);
            when(mockQuery.setParameter(anyString(), any())).thenReturn(mockQuery);
            when(mockQuery.getResultList()).thenReturn(List.of());

            List<BestSellingDrink> list = statisticDAO.getTop5BestSellingDrinks(fromDate, toDate);
            assertTrue(list.isEmpty());
        }
    }

    @Test
    @Order(3)
    @DisplayName("getTop5BestSellingDrinks() - fromDate và toDate null không gây lỗi")
    void testTop5BestSelling_NullDates() throws Exception {
        Query mockQuery = mock(Query.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createNativeQuery(anyString())).thenReturn(mockQuery);
            when(mockQuery.setParameter(anyString(), any())).thenReturn(mockQuery);
            when(mockQuery.getResultList()).thenReturn(List.of());

            List<BestSellingDrink> list = statisticDAO.getTop5BestSellingDrinks(null, null);
            assertNotNull(list);
        }
    }

    @Test
    @Order(4)
    @DisplayName("getRevenueByDay() - Trả về doanh thu từng ngày")
    void testRevenueByDay_ReturnsList() throws Exception {
        Query mockQuery = mock(Query.class);
        List<Object[]> resultList = List.of(
                new Object[] { new Date(System.currentTimeMillis()), 5, 500000L },
                new Object[] { new Date(System.currentTimeMillis() - 86400000), 3, 300000L });

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createNativeQuery(anyString())).thenReturn(mockQuery);
            when(mockQuery.setParameter(anyString(), any())).thenReturn(mockQuery);
            when(mockQuery.getResultList()).thenReturn(resultList);

            List<RevenueByDay> list = statisticDAO.getRevenueByDay(fromDate, toDate);
            assertEquals(2, list.size());
            assertEquals(5, list.get(0).getTotalBills());
            assertEquals(500000L, list.get(0).getTotalRevenue());
        }
    }

    @Test
    @Order(5)
    @DisplayName("getRevenueByDay() - Không có hóa đơn trong khoảng ngày trả về rỗng")
    void testRevenueByDay_Empty() throws Exception {
        Query mockQuery = mock(Query.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createNativeQuery(anyString())).thenReturn(mockQuery);
            when(mockQuery.setParameter(anyString(), any())).thenReturn(mockQuery);
            when(mockQuery.getResultList()).thenReturn(List.of());

            List<RevenueByDay> list = statisticDAO.getRevenueByDay(fromDate, toDate);
            assertTrue(list.isEmpty());
        }
    }

    @Test
    @Order(6)
    @DisplayName("getTotalRevenue() - Trả về đúng tổng doanh thu")
    void testGetTotalRevenue_Value() throws Exception {
        Query mockQuery = mock(Query.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createNativeQuery(anyString())).thenReturn(mockQuery);
            when(mockQuery.setParameter(anyString(), any())).thenReturn(mockQuery);
            when(mockQuery.getSingleResult()).thenReturn(1500000.0);

            double total = statisticDAO.getTotalRevenue(fromDate, toDate);
            assertEquals(1500000.0, total, 0.01);
        }
    }

    @Test
    @Order(7)
    @DisplayName("getTotalRevenue() - Không có dữ liệu trả về 0")
    void testGetTotalRevenue_Zero() throws Exception {
        Query mockQuery = mock(Query.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createNativeQuery(anyString())).thenReturn(mockQuery);
            when(mockQuery.setParameter(anyString(), any())).thenReturn(mockQuery);
            when(mockQuery.getSingleResult()).thenReturn(0.0);

            double total = statisticDAO.getTotalRevenue(fromDate, toDate);
            assertEquals(0.0, total, 0.01);
        }
    }

    @Test
    @Order(8)
    @DisplayName("getTotalBills() - Đếm đúng số hóa đơn")
    void testGetTotalBills_Count() throws Exception {
        Query mockQuery = mock(Query.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createNativeQuery(anyString())).thenReturn(mockQuery);
            when(mockQuery.setParameter(anyString(), any())).thenReturn(mockQuery);
            when(mockQuery.getSingleResult()).thenReturn(42);

            int count = statisticDAO.getTotalBills(fromDate, toDate);
            assertEquals(42, count);
        }
    }

    @Test
    @Order(9)
    @DisplayName("getTotalBills() - Không có hóa đơn trả về 0")
    void testGetTotalBills_Zero() throws Exception {
        Query mockQuery = mock(Query.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createNativeQuery(anyString())).thenReturn(mockQuery);
            when(mockQuery.setParameter(anyString(), any())).thenReturn(mockQuery);
            when(mockQuery.getSingleResult()).thenReturn(0);

            int count = statisticDAO.getTotalBills(fromDate, toDate);
            assertEquals(0, count);
        }
    }
}