package dao;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
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

import entity.PointTransaction;
import util.JdbcUtil;

/**
 * Unit test cho PointDAO
 */
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class PointDAOTest {

    private PointDAO pointDAO;

    @BeforeEach
    void setUp() {
        pointDAO = new PointDAO();
    }

    private ResultSet mockPointRs(int id, int bonus, int deduct, int customerId, int billId) throws Exception {
        ResultSet rs = mock(ResultSet.class);
        when(rs.next()).thenReturn(true, false);
        when(rs.getInt("id")).thenReturn(id);
        when(rs.getInt("bonus_point")).thenReturn(bonus);
        when(rs.getInt("deduct_point")).thenReturn(deduct);
        when(rs.getDate("transaction_date")).thenReturn(Date.valueOf("2024-06-01"));
        when(rs.getString("note")).thenReturn("Test note");
        when(rs.getInt("customer_id")).thenReturn(customerId);
        when(rs.getInt("bill_id")).thenReturn(billId);
        return rs;
    }

    // ===================== CREATE =====================

    @Test
    @Order(1)
    @DisplayName("create() - Ghi giao dịch điểm thành công")
    void testCreate_Success() throws Exception {
        PointTransaction p = new PointTransaction(null, 10, 0,
                new java.util.Date(), "Tich diem hoa don #1", 1, 1);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(),
                    any(), any(), any(), any(), any(), any()))
                    .thenReturn(1);

            int result = pointDAO.create(p);
            assertEquals(1, result);
        }
    }

    // ===================== FIND ALL =====================

    @Test
    @Order(2)
    @DisplayName("findAll() - Trả về lịch sử điểm")
    void testFindAll() throws Exception {
        ResultSet rs = mock(ResultSet.class);
        when(rs.next()).thenReturn(true, false);
        when(rs.getInt("id")).thenReturn(1);
        when(rs.getInt("bonus_point")).thenReturn(10);
        when(rs.getInt("deduct_point")).thenReturn(0);
        when(rs.getDate("transaction_date")).thenReturn(Date.valueOf("2024-06-01"));
        when(rs.getString("note")).thenReturn("note");
        when(rs.getInt("customer_id")).thenReturn(1);
        when(rs.getInt("bill_id")).thenReturn(1);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString())).thenReturn(rs);

            List<PointTransaction> list = pointDAO.findAll();
            assertEquals(1, list.size());
        }
    }

    // ===================== FIND BY CUSTOMER ID =====================

    @Test
    @Order(3)
    @DisplayName("findByCustomerId() - Lịch sử điểm của khách hàng")
    void testFindByCustomerId() throws Exception {
        ResultSet rs = mockPointRs(1, 10, 0, 1, 1);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), eq(1))).thenReturn(rs);

            List<PointTransaction> list = pointDAO.findByCustomerId(1);
            assertEquals(1, list.size());
            assertEquals(10, list.get(0).getBonusPoint());
        }
    }

    @Test
    @Order(4)
    @DisplayName("findByCustomerId() - Khách chưa có lịch sử trả về rỗng")
    void testFindByCustomerId_Empty() throws Exception {
        ResultSet rs = mock(ResultSet.class);
        when(rs.next()).thenReturn(false);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), eq(99))).thenReturn(rs);

            List<PointTransaction> list = pointDAO.findByCustomerId(99);
            assertTrue(list.isEmpty());
        }
    }

    // ===================== FIND BY BILL ID =====================

    @Test
    @Order(5)
    @DisplayName("findByBillId() - Lấy giao dịch điểm theo hóa đơn")
    void testFindByBillId_Found() throws Exception {
        ResultSet rs = mockPointRs(1, 5, 0, 1, 1);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), eq(1))).thenReturn(rs);

            PointTransaction p = pointDAO.findByBillId(1);
            assertNotNull(p);
            assertEquals(1, p.getBillId());
        }
    }

    // ===================== CALC BONUS POINT =====================

    @Test
    @Order(6)
    @DisplayName("calcBonusPoint() - 10,000 VNĐ = 1 điểm")
    void testCalcBonusPoint_Standard() {
        // 50,000 / 10,000 = 5 điểm
        int points = pointDAO.calcBonusPoint(50000);
        assertEquals(5, points);
    }

    @Test
    @Order(7)
    @DisplayName("calcBonusPoint() - Số tiền không tròn → làm tròn xuống")
    void testCalcBonusPoint_Truncate() {
        // 55,999 / 10,000 = 5 điểm (phần lẻ bị bỏ)
        int points = pointDAO.calcBonusPoint(55999);
        assertEquals(5, points);
    }

    @Test
    @Order(8)
    @DisplayName("calcBonusPoint() - Dưới 10,000 VNĐ = 0 điểm")
    void testCalcBonusPoint_BelowThreshold() {
        int points = pointDAO.calcBonusPoint(9999);
        assertEquals(0, points);
    }

    // ===================== UPDATE/DELETE (Lịch sử không thay đổi)
    // =====================

    @Test
    @Order(9)
    @DisplayName("update() - Luôn trả về 0 (lịch sử không chỉnh sửa)")
    void testUpdate_AlwaysZero() {
        PointTransaction p = new PointTransaction(1, 10, 0, new java.util.Date(), "note", 1, 1);
        int result = pointDAO.update(p);
        assertEquals(0, result);
    }

    @Test
    @Order(10)
    @DisplayName("delete() - Luôn trả về 0 (lịch sử không xóa)")
    void testDelete_AlwaysZero() {
        int result = pointDAO.delete(1);
        assertEquals(0, result);
    }

    // ===================== CONSTANTS =====================

    @Test
    @Order(11)
    @DisplayName("Hằng số AMOUNT_PER_POINT phải là 10,000")
    void testConstant_AmountPerPoint() {
        assertEquals(10_000.0, PointDAO.AMOUNT_PER_POINT, 0.01);
    }

    @Test
    @Order(12)
    @DisplayName("Hằng số POINT_VALUE phải là 1,000")
    void testConstant_PointValue() {
        assertEquals(1_000.0, PointDAO.POINT_VALUE, 0.01);
    }
}