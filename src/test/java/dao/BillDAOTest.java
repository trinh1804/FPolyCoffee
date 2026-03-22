package dao;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
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

import entity.Bill;
import util.JdbcUtil;

/**
 * Unit test cho BillDAO
 */
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class BillDAOTest {

    private BillDAO billDAO;

    @BeforeEach
    void setUp() {
        billDAO = new BillDAO();
    }

    private ResultSet mockBillRs(int id, int status) throws Exception {
        ResultSet rs = mock(ResultSet.class);
        when(rs.next()).thenReturn(true, false);
        when(rs.getInt("id")).thenReturn(id);
        when(rs.getDate("created_at")).thenReturn(Date.valueOf("2024-06-01"));
        when(rs.getDouble("total_price")).thenReturn(100000.0);
        when(rs.getDouble("discount_amount")).thenReturn(0.0);
        when(rs.getBoolean("payment_method")).thenReturn(false);
        when(rs.getInt("status")).thenReturn(status);
        when(rs.getString("code")).thenReturn("BILL-001");
        when(rs.getInt("user_id")).thenReturn(1);
        when(rs.wasNull()).thenReturn(false); // user_id, customer_id, discount_id không null
        when(rs.getInt("customer_id")).thenReturn(0);
        when(rs.getInt("discount_id")).thenReturn(0);
        return rs;
    }

    // ===================== CREATE =====================

    @Test
    @Order(1)
    @DisplayName("create() - Thêm hóa đơn mới thành công")
    void testCreate_Success() throws Exception {
        Bill bill = new Bill();
        bill.setCreatedAt(new java.util.Date());
        bill.setTotalPrice(100000);
        bill.setDiscountAmount(0);
        bill.setPaymentMethod(false);
        bill.setStatus(0);
        bill.setCode("BILL-001");
        bill.setUserId(1);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(),
                    any(), any(), any(), any(), any(), any(), any(), any(), any()))
                    .thenReturn(1);

            int result = billDAO.create(bill);
            assertEquals(1, result);
        }
    }

    // ===================== UPDATE =====================

    @Test
    @Order(2)
    @DisplayName("update() - Cập nhật hóa đơn thành công")
    void testUpdate_Success() throws Exception {
        Bill bill = new Bill();
        bill.setId(1);
        bill.setTotalPrice(120000);
        bill.setDiscountAmount(10000);
        bill.setPaymentMethod(true);
        bill.setStatus(1);
        bill.setCustomerId(2);
        bill.setDiscountId(1);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(),
                    any(), any(), any(), any(), any(), any(), any()))
                    .thenReturn(1);

            int result = billDAO.update(bill);
            assertEquals(1, result);
        }
    }

    // ===================== FIND ALL =====================

    @Test
    @Order(3)
    @DisplayName("findAll() - Trả về danh sách hóa đơn")
    void testFindAll() throws Exception {
        ResultSet rs = mock(ResultSet.class);
        when(rs.next()).thenReturn(true, false);
        when(rs.getInt("id")).thenReturn(1);
        when(rs.getDate("created_at")).thenReturn(Date.valueOf("2024-06-01"));
        when(rs.getDouble("total_price")).thenReturn(100000.0);
        when(rs.getDouble("discount_amount")).thenReturn(0.0);
        when(rs.getBoolean("payment_method")).thenReturn(false);
        when(rs.getInt("status")).thenReturn(0);
        when(rs.getString("code")).thenReturn("BILL-001");
        when(rs.getInt("user_id")).thenReturn(1);
        when(rs.wasNull()).thenReturn(false);
        when(rs.getInt("customer_id")).thenReturn(0);
        when(rs.getInt("discount_id")).thenReturn(0);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString())).thenReturn(rs);

            List<Bill> list = billDAO.findAll();
            assertEquals(1, list.size());
        }
    }

    // ===================== FIND BY ID =====================

    @Test
    @Order(4)
    @DisplayName("findById() - Tìm thấy hóa đơn")
    void testFindById_Found() throws Exception {
        ResultSet rs = mockBillRs(1, 0);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), eq(1))).thenReturn(rs);

            Bill bill = billDAO.findById(1);
            assertNotNull(bill);
            assertEquals("BILL-001", bill.getCode());
        }
    }

    @Test
    @Order(5)
    @DisplayName("findById() - Không tìm thấy trả về null")
    void testFindById_NotFound() throws Exception {
        ResultSet rs = mock(ResultSet.class);
        when(rs.next()).thenReturn(false);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), eq(999))).thenReturn(rs);

            Bill bill = billDAO.findById(999);
            assertNull(bill);
        }
    }

    // ===================== UPDATE STATUS =====================

    @Test
    @Order(6)
    @DisplayName("updateStatus() - Chuyển từ waiting → finish hợp lệ")
    void testUpdateStatus_WaitingToFinish() throws Exception {
        ResultSet rsFindById = mockBillRs(1, Bill.STATUS_WAITING);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            // findById gọi executeQuery
            mock.when(() -> JdbcUtil.executeQuery(anyString(), eq(1))).thenReturn(rsFindById);
            // update gọi executeUpdate
            mock.when(() -> JdbcUtil.executeUpdate(anyString(), eq(Bill.STATUS_FINISH), eq(1)))
                    .thenReturn(1);

            int result = billDAO.updateStatus(1, Bill.STATUS_FINISH);
            assertEquals(1, result);
        }
    }

    @Test
    @Order(7)
    @DisplayName("updateStatus() - Chuyển từ waiting → cancel hợp lệ")
    void testUpdateStatus_WaitingToCancel() throws Exception {
        ResultSet rs = mockBillRs(1, Bill.STATUS_WAITING);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), eq(1))).thenReturn(rs);
            mock.when(() -> JdbcUtil.executeUpdate(anyString(), eq(Bill.STATUS_CANCEL), eq(1)))
                    .thenReturn(1);

            int result = billDAO.updateStatus(1, Bill.STATUS_CANCEL);
            assertEquals(1, result);
        }
    }

    @Test
    @Order(8)
    @DisplayName("updateStatus() - Chuyển trạng thái không hợp lệ (finish → waiting) trả về 0")
    void testUpdateStatus_InvalidTransition() throws Exception {
        // Bill đang ở trạng thái FINISH
        ResultSet rs = mockBillRs(1, Bill.STATUS_FINISH);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), eq(1))).thenReturn(rs);

            // Thử chuyển về WAITING → không hợp lệ → phải trả về 0
            int result = billDAO.updateStatus(1, Bill.STATUS_WAITING);
            assertEquals(0, result);
        }
    }

    @Test
    @Order(9)
    @DisplayName("updateStatus() - Bill không tồn tại trả về 0")
    void testUpdateStatus_BillNotFound() throws Exception {
        ResultSet rs = mock(ResultSet.class);
        when(rs.next()).thenReturn(false);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), eq(999))).thenReturn(rs);

            int result = billDAO.updateStatus(999, Bill.STATUS_FINISH);
            assertEquals(0, result);
        }
    }

    // ===================== APPLY DISCOUNT =====================

    @Test
    @Order(10)
    @DisplayName("applyDiscount() - Áp mã giảm giá vào bill đang chờ")
    void testApplyDiscount_Success() throws Exception {
        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(), eq(1), eq(10000.0), eq(1)))
                    .thenReturn(1);

            int result = billDAO.applyDiscount(1, 1, 10000.0);
            assertEquals(1, result);
        }
    }

    // ===================== ASSIGN CUSTOMER =====================

    @Test
    @Order(11)
    @DisplayName("assignCustomer() - Gán khách hàng vào bill")
    void testAssignCustomer_Success() throws Exception {
        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(), eq(5), eq(1)))
                    .thenReturn(1);

            int result = billDAO.assignCustomer(1, 5);
            assertEquals(1, result);
        }
    }

    // ===================== GET REVENUE =====================

    @Test
    @Order(12)
    @DisplayName("getTotalRevenueByDateRange() - Tổng doanh thu đúng")
    void testGetTotalRevenue() throws Exception {
        ResultSet rs = mock(ResultSet.class);
        when(rs.next()).thenReturn(true);
        when(rs.getDouble("rev")).thenReturn(500000.0);

        java.util.Date from = new java.util.Date();
        java.util.Date to = new java.util.Date();

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), any(), any())).thenReturn(rs);

            double revenue = billDAO.getTotalRevenueByDateRange(from, to);
            assertEquals(500000.0, revenue, 0.01);
        }
    }
}