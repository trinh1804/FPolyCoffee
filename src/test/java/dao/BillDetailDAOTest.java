package dao;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockStatic;
import static org.mockito.Mockito.when;

import java.sql.ResultSet;
import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;
import org.mockito.MockedStatic;

import entity.BillDetail;
import util.JdbcUtil;

/**
 * Unit test cho BillDetailDAO
 */
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class BillDetailDAOTest {

    private BillDetailDAO billDetailDAO;

    @BeforeEach
    void setUp() {
        billDetailDAO = new BillDetailDAO();
    }

    private ResultSet mockDetailRs(int billId, int drinkId, int qty, double price) throws Exception {
        ResultSet rs = mock(ResultSet.class);
        when(rs.next()).thenReturn(true, false);
        when(rs.getInt("bill_id")).thenReturn(billId);
        when(rs.getInt("drink_id")).thenReturn(drinkId);
        when(rs.getInt("quantity")).thenReturn(qty);
        when(rs.getDouble("unit_price")).thenReturn(price);
        when(rs.getDouble("total_price")).thenReturn(qty * price);
        return rs;
    }

    // ===================== CREATE =====================

    @Test
    @Order(1)
    @DisplayName("create() - Thêm chi tiết hóa đơn thành công, tự tính total_price")
    void testCreate_AutoCalcTotalPrice() throws Exception {
        BillDetail detail = new BillDetail(1, 2, 3, 25000.0, 0);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(),
                    eq(1), eq(2), eq(3), eq(25000.0), eq(75000.0)))
                    .thenReturn(1);

            int result = billDetailDAO.create(detail);
            assertEquals(1, result);
            // total_price phải được tính tự động = qty * price
            assertEquals(75000.0, detail.getTotalPrice(), 0.01);
        }
    }

    // ===================== UPDATE =====================

    @Test
    @Order(2)
    @DisplayName("update() - Cập nhật số lượng, tự tính lại total_price")
    void testUpdate_RecalcTotalPrice() throws Exception {
        BillDetail detail = new BillDetail(1, 2, 5, 25000.0, 0);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(),
                    eq(5), eq(25000.0), eq(125000.0), eq(1), eq(2)))
                    .thenReturn(1);

            int result = billDetailDAO.update(detail);
            assertEquals(1, result);
            assertEquals(125000.0, detail.getTotalPrice(), 0.01);
        }
    }

    // ===================== DELETE =====================

    @Test
    @Order(3)
    @DisplayName("deleteByBillAndDrink() - Xóa chi tiết theo bill và drink")
    void testDeleteByBillAndDrink_Success() throws Exception {
        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(), eq(1), eq(2)))
                    .thenReturn(1);

            int result = billDetailDAO.deleteByBillAndDrink(1, 2);
            assertEquals(1, result);
        }
    }

    @Test
    @Order(4)
    @DisplayName("deleteByBillId() - Xóa tất cả chi tiết của một hóa đơn")
    void testDeleteByBillId_Success() throws Exception {
        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(), eq(1)))
                    .thenReturn(3); // xóa 3 dòng

            int result = billDetailDAO.deleteByBillId(1);
            assertEquals(3, result);
        }
    }

    // ===================== FIND BY BILL ID =====================

    @Test
    @Order(5)
    @DisplayName("findByBillId() - Trả về danh sách chi tiết theo hóa đơn")
    void testFindByBillId_ReturnsList() throws Exception {
        ResultSet rs = mock(ResultSet.class);
        when(rs.next()).thenReturn(true, true, false);
        when(rs.getInt("bill_id")).thenReturn(1, 1);
        when(rs.getInt("drink_id")).thenReturn(1, 2);
        when(rs.getInt("quantity")).thenReturn(2, 1);
        when(rs.getDouble("unit_price")).thenReturn(25000.0, 30000.0);
        when(rs.getDouble("total_price")).thenReturn(50000.0, 30000.0);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), eq(1))).thenReturn(rs);

            List<BillDetail> list = billDetailDAO.findByBillId(1);
            assertEquals(2, list.size());
            assertEquals(1, list.get(0).getBillId());
        }
    }

    @Test
    @Order(6)
    @DisplayName("findByBillId() - Hóa đơn không có chi tiết trả về rỗng")
    void testFindByBillId_Empty() throws Exception {
        ResultSet rs = mock(ResultSet.class);
        when(rs.next()).thenReturn(false);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), eq(99))).thenReturn(rs);

            List<BillDetail> list = billDetailDAO.findByBillId(99);
            assertTrue(list.isEmpty());
        }
    }

    // ===================== FIND BY BILL AND DRINK =====================

    @Test
    @Order(7)
    @DisplayName("findByBillAndDrink() - Tìm thấy chi tiết theo bill+drink")
    void testFindByBillAndDrink_Found() throws Exception {
        ResultSet rs = mockDetailRs(1, 2, 3, 25000.0);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), eq(1), eq(2))).thenReturn(rs);

            BillDetail detail = billDetailDAO.findByBillAndDrink(1, 2);
            assertNotNull(detail);
            assertEquals(3, detail.getQuantity());
        }
    }

    @Test
    @Order(8)
    @DisplayName("findByBillAndDrink() - Không tìm thấy trả về null")
    void testFindByBillAndDrink_NotFound() throws Exception {
        ResultSet rs = mock(ResultSet.class);
        when(rs.next()).thenReturn(false);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), eq(1), eq(99))).thenReturn(rs);

            BillDetail detail = billDetailDAO.findByBillAndDrink(1, 99);
            assertNull(detail);
        }
    }

    // ===================== UPDATE QUANTITY =====================

    @Test
    @Order(9)
    @DisplayName("updateQuantity() - Cập nhật số lượng > 0")
    void testUpdateQuantity_Positive() throws Exception {
        // findByBillAndDrink mock
        ResultSet rsFindRs = mockDetailRs(1, 2, 3, 25000.0);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), eq(1), eq(2))).thenReturn(rsFindRs);
            mock.when(() -> JdbcUtil.executeUpdate(anyString(),
                    eq(5), eq(25000.0), eq(125000.0), eq(1), eq(2)))
                    .thenReturn(1);

            int result = billDetailDAO.updateQuantity(1, 2, 5);
            assertEquals(1, result);
        }
    }

    @Test
    @Order(10)
    @DisplayName("updateQuantity() - Số lượng <= 0 → tự động xóa dòng đó")
    void testUpdateQuantity_ZeroAutoDelete() throws Exception {
        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(), eq(1), eq(2)))
                    .thenReturn(1);

            int result = billDetailDAO.updateQuantity(1, 2, 0);
            assertEquals(1, result);
        }
    }
}