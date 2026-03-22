package dao;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockStatic;
import static org.mockito.Mockito.when;

import java.sql.Date;
import java.sql.ResultSet;
import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;
import org.mockito.MockedStatic;

import entity.BestSellingDrink;
import entity.RevenueByDay;
import util.JdbcUtil;

/**
 * Unit test cho StatisticDAO
 */
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class StatisticDAOTest {

    private StatisticDAO statisticDAO;
    private java.util.Date fromDate;
    private java.util.Date toDate;

    @BeforeEach
    void setUp() {
        statisticDAO = new StatisticDAO();
        fromDate = java.sql.Date.valueOf("2024-01-01");
        toDate = java.sql.Date.valueOf("2024-12-31");
    }

    // ===================== TOP 5 BEST SELLING =====================

    @Test
    @Order(1)
    @DisplayName("getTop5BestSellingDrinks() - Trả về danh sách đúng")
    void testTop5BestSelling_ReturnsList() throws Exception {
        ResultSet rs = mock(ResultSet.class);
        when(rs.next()).thenReturn(true, true, false);
        when(rs.getInt("drink_id")).thenReturn(1, 2);
        when(rs.getString("drink_name")).thenReturn("Cafe Den", "Tra Xanh");
        when(rs.getInt("total_quantity_sold")).thenReturn(100, 80);
        when(rs.getLong("total_revenue")).thenReturn(2500000L, 1600000L);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), any(), any(), any(), any()))
                    .thenReturn(rs);

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
        ResultSet rs = mock(ResultSet.class);
        when(rs.next()).thenReturn(false);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), any(), any(), any(), any()))
                    .thenReturn(rs);

            List<BestSellingDrink> list = statisticDAO.getTop5BestSellingDrinks(fromDate, toDate);
            assertTrue(list.isEmpty());
        }
    }

    @Test
    @Order(3)
    @DisplayName("getTop5BestSellingDrinks() - fromDate và toDate null không gây lỗi")
    void testTop5BestSelling_NullDates() throws Exception {
        ResultSet rs = mock(ResultSet.class);
        when(rs.next()).thenReturn(false);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), any(), any(), any(), any()))
                    .thenReturn(rs);

            List<BestSellingDrink> list = statisticDAO.getTop5BestSellingDrinks(null, null);
            assertNotNull(list); // không ném exception
        }
    }

    // ===================== REVENUE BY DAY =====================

    @Test
    @Order(4)
    @DisplayName("getRevenueByDay() - Trả về doanh thu từng ngày")
    void testRevenueByDay_ReturnsList() throws Exception {
        ResultSet rs = mock(ResultSet.class);
        when(rs.next()).thenReturn(true, true, false);
        when(rs.getDate("revenue_date"))
                .thenReturn(Date.valueOf("2024-06-01"), Date.valueOf("2024-06-02"));
        when(rs.getInt("total_bills")).thenReturn(5, 3);
        when(rs.getLong("total_revenue")).thenReturn(500000L, 300000L);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), any(), any())).thenReturn(rs);

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
        ResultSet rs = mock(ResultSet.class);
        when(rs.next()).thenReturn(false);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), any(), any())).thenReturn(rs);

            List<RevenueByDay> list = statisticDAO.getRevenueByDay(fromDate, toDate);
            assertTrue(list.isEmpty());
        }
    }

    // ===================== GET TOTAL REVENUE =====================

    @Test
    @Order(6)
    @DisplayName("getTotalRevenue() - Trả về đúng tổng doanh thu")
    void testGetTotalRevenue_Value() throws Exception {
        ResultSet rs = mock(ResultSet.class);
        when(rs.next()).thenReturn(true);
        when(rs.getDouble("total")).thenReturn(1500000.0);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), any(), any())).thenReturn(rs);

            double total = statisticDAO.getTotalRevenue(fromDate, toDate);
            assertEquals(1500000.0, total, 0.01);
        }
    }

    @Test
    @Order(7)
    @DisplayName("getTotalRevenue() - Không có dữ liệu trả về 0")
    void testGetTotalRevenue_Zero() throws Exception {
        ResultSet rs = mock(ResultSet.class);
        when(rs.next()).thenReturn(true);
        when(rs.getDouble("total")).thenReturn(0.0);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), any(), any())).thenReturn(rs);

            double total = statisticDAO.getTotalRevenue(fromDate, toDate);
            assertEquals(0.0, total, 0.01);
        }
    }

    // ===================== GET TOTAL BILLS =====================

    @Test
    @Order(8)
    @DisplayName("getTotalBills() - Đếm đúng số hóa đơn")
    void testGetTotalBills_Count() throws Exception {
        ResultSet rs = mock(ResultSet.class);
        when(rs.next()).thenReturn(true);
        when(rs.getInt("cnt")).thenReturn(42);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), any(), any())).thenReturn(rs);

            int count = statisticDAO.getTotalBills(fromDate, toDate);
            assertEquals(42, count);
        }
    }

    @Test
    @Order(9)
    @DisplayName("getTotalBills() - Không có hóa đơn trả về 0")
    void testGetTotalBills_Zero() throws Exception {
        ResultSet rs = mock(ResultSet.class);
        when(rs.next()).thenReturn(true);
        when(rs.getInt("cnt")).thenReturn(0);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), any(), any())).thenReturn(rs);

            int count = statisticDAO.getTotalBills(fromDate, toDate);
            assertEquals(0, count);
        }
    }
}