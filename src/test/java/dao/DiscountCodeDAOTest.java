package dao;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
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

import entity.DiscountCode;
import util.JdbcUtil;

/**
 * Unit test cho DiscountCodeDAO
 */
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class DiscountCodeDAOTest {

    private DiscountCodeDAO discountDAO;

    @BeforeEach
    void setUp() {
        discountDAO = new DiscountCodeDAO();
    }

    private ResultSet mockDiscountRs(int id, String code, double value,
            boolean type, boolean status) throws Exception {
        ResultSet rs = mock(ResultSet.class);
        when(rs.next()).thenReturn(true, false);
        when(rs.getInt("id")).thenReturn(id);
        when(rs.getString("code")).thenReturn(code);
        when(rs.getDouble("discount_value")).thenReturn(value);
        when(rs.getBoolean("discount_type")).thenReturn(type);
        when(rs.getDate("start_date")).thenReturn(Date.valueOf("2024-01-01"));
        when(rs.getDate("end_date")).thenReturn(Date.valueOf("2030-12-31"));
        when(rs.getBoolean("status")).thenReturn(status);
        when(rs.getString("condition_note")).thenReturn("Dieu kien ap dung");
        return rs;
    }

    // ===================== CREATE =====================

    @Test
    @Order(1)
    @DisplayName("create() - Thêm mã giảm giá cố định thành công")
    void testCreate_FixedDiscount() throws Exception {
        DiscountCode dc = new DiscountCode(0, "GIAM10K", 10000, false,
                new java.util.Date(), new java.util.Date(), true, "Giam 10k");

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(),
                    any(), any(), any(), any(), any(), any(), any()))
                    .thenReturn(1);

            int result = discountDAO.create(dc);
            assertEquals(1, result);
        }
    }

    @Test
    @Order(2)
    @DisplayName("create() - Thêm mã giảm giá phần trăm thành công")
    void testCreate_PercentDiscount() throws Exception {
        DiscountCode dc = new DiscountCode(0, "GIAM20P", 20, true,
                new java.util.Date(), new java.util.Date(), true, "Giam 20%");

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(),
                    any(), any(), any(), any(), any(), any(), any()))
                    .thenReturn(1);

            int result = discountDAO.create(dc);
            assertEquals(1, result);
        }
    }

    // ===================== UPDATE =====================

    @Test
    @Order(3)
    @DisplayName("update() - Cập nhật mã giảm giá thành công")
    void testUpdate_Success() throws Exception {
        DiscountCode dc = new DiscountCode(1, "GIAM10K", 15000, false,
                new java.util.Date(), new java.util.Date(), true, "Updated");

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(),
                    any(), any(), any(), any(), any(), any(), any(), any()))
                    .thenReturn(1);

            int result = discountDAO.update(dc);
            assertEquals(1, result);
        }
    }

    // ===================== DELETE =====================

    @Test
    @Order(4)
    @DisplayName("delete() - Xóa mã giảm giá thành công")
    void testDelete_Success() throws Exception {
        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(), eq(1)))
                    .thenReturn(1);

            int result = discountDAO.delete(1);
            assertEquals(1, result);
        }
    }

    // ===================== FIND ALL =====================

    @Test
    @Order(5)
    @DisplayName("findAll() - Trả về danh sách mã giảm giá")
    void testFindAll() throws Exception {
        ResultSet rs = mock(ResultSet.class);
        when(rs.next()).thenReturn(true, false);
        when(rs.getInt("id")).thenReturn(1);
        when(rs.getString("code")).thenReturn("GIAM10K");
        when(rs.getDouble("discount_value")).thenReturn(10000.0);
        when(rs.getBoolean("discount_type")).thenReturn(false);
        when(rs.getDate("start_date")).thenReturn(Date.valueOf("2024-01-01"));
        when(rs.getDate("end_date")).thenReturn(Date.valueOf("2030-12-31"));
        when(rs.getBoolean("status")).thenReturn(true);
        when(rs.getString("condition_note")).thenReturn("dieu kien");

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString())).thenReturn(rs);

            List<DiscountCode> list = discountDAO.findAll();
            assertEquals(1, list.size());
            assertEquals("GIAM10K", list.get(0).getCode());
        }
    }

    // ===================== FIND BY ID =====================

    @Test
    @Order(6)
    @DisplayName("findById() - Tìm thấy mã theo id")
    void testFindById_Found() throws Exception {
        ResultSet rs = mockDiscountRs(1, "GIAM10K", 10000, false, true);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), eq(1))).thenReturn(rs);

            DiscountCode dc = discountDAO.findById(1);
            assertNotNull(dc);
            assertEquals("GIAM10K", dc.getCode());
        }
    }

    @Test
    @Order(7)
    @DisplayName("findById() - Không tìm thấy trả về null")
    void testFindById_NotFound() throws Exception {
        ResultSet rs = mock(ResultSet.class);
        when(rs.next()).thenReturn(false);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), eq(999))).thenReturn(rs);

            DiscountCode dc = discountDAO.findById(999);
            assertNull(dc);
        }
    }

    // ===================== FIND BY CODE =====================

    @Test
    @Order(8)
    @DisplayName("findByCode() - Tìm mã còn hiệu lực")
    void testFindByCode_Valid() throws Exception {
        ResultSet rs = mockDiscountRs(1, "GIAM10K", 10000, false, true);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), eq("GIAM10K"), any(), any()))
                    .thenReturn(rs);

            DiscountCode dc = discountDAO.findByCode("GIAM10K");
            assertNotNull(dc);
            assertTrue(dc.isActive());
        }
    }

    @Test
    @Order(9)
    @DisplayName("findByCode() - Mã không tồn tại hoặc hết hạn trả về null")
    void testFindByCode_Expired() throws Exception {
        ResultSet rs = mock(ResultSet.class);
        when(rs.next()).thenReturn(false);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), eq("HETHAN"), any(), any()))
                    .thenReturn(rs);

            DiscountCode dc = discountDAO.findByCode("HETHAN");
            assertNull(dc);
        }
    }

    // ===================== CALCULATE DISCOUNT =====================

    @Test
    @Order(10)
    @DisplayName("calculateDiscount() - Giảm giá cố định: min(value, total)")
    void testCalcDiscount_Fixed() {
        DiscountCode dc = new DiscountCode(1, "CODE", 10000, false,
                new java.util.Date(), new java.util.Date(), true, "");

        // 10000 < 50000 → giảm đúng 10000
        double discount = discountDAO.calculateDiscount(dc, 50000);
        assertEquals(10000.0, discount, 0.01);
    }

    @Test
    @Order(11)
    @DisplayName("calculateDiscount() - Giảm giá cố định không vượt quá total_price")
    void testCalcDiscount_FixedCapAtTotal() {
        DiscountCode dc = new DiscountCode(1, "CODE", 100000, false,
                new java.util.Date(), new java.util.Date(), true, "");

        // 100000 > 30000 → chỉ giảm 30000 (tổng tiền)
        double discount = discountDAO.calculateDiscount(dc, 30000);
        assertEquals(30000.0, discount, 0.01);
    }

    @Test
    @Order(12)
    @DisplayName("calculateDiscount() - Giảm giá theo phần trăm")
    void testCalcDiscount_Percent() {
        DiscountCode dc = new DiscountCode(1, "CODE", 20, true,
                new java.util.Date(), new java.util.Date(), true, "");

        // 20% của 100000 = 20000
        double discount = discountDAO.calculateDiscount(dc, 100000);
        assertEquals(20000.0, discount, 0.01);
    }

    @Test
    @Order(13)
    @DisplayName("calculateDiscount() - Mã null trả về 0")
    void testCalcDiscount_NullCode() {
        double discount = discountDAO.calculateDiscount(null, 100000);
        assertEquals(0.0, discount, 0.01);
    }
}