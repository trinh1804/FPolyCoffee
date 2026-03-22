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

import entity.Customer;
import util.JdbcUtil;

/**
 * Unit test cho CustomerDAO
 */
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class CustomerDAOTest {

    private CustomerDAO customerDAO;

    @BeforeEach
    void setUp() {
        customerDAO = new CustomerDAO();
    }

    private ResultSet mockCustomerRs(int id, String name, String phone, int point, boolean status) throws Exception {
        ResultSet rs = mock(ResultSet.class);
        when(rs.next()).thenReturn(true, false);
        when(rs.getInt("id")).thenReturn(id);
        when(rs.getString("fullname")).thenReturn(name);
        when(rs.getString("phone")).thenReturn(phone);
        when(rs.getString("email")).thenReturn("email@test.com");
        when(rs.getInt("point")).thenReturn(point);
        when(rs.getBoolean("status")).thenReturn(status);
        when(rs.getDate("created_at")).thenReturn(Date.valueOf("2024-01-01"));
        return rs;
    }

    // ===================== CREATE =====================

    @Test
    @Order(1)
    @DisplayName("create() - Thêm khách hàng thành công")
    void testCreate_Success() throws Exception {
        Customer c = new Customer(0, "Nguyen Van A", "0901234567",
                "a@gmail.com", 0, true, new java.util.Date());

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(),
                    any(), any(), any(), any(), any(), any()))
                    .thenReturn(1);

            int result = customerDAO.create(c);
            assertEquals(1, result);
        }
    }

    // ===================== UPDATE =====================

    @Test
    @Order(2)
    @DisplayName("update() - Cập nhật thông tin khách hàng")
    void testUpdate_Success() throws Exception {
        Customer c = new Customer(1, "Nguyen Van B", "0902222222",
                "b@gmail.com", 100, true, new java.util.Date());

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(),
                    any(), any(), any(), any(), any()))
                    .thenReturn(1);

            int result = customerDAO.update(c);
            assertEquals(1, result);
        }
    }

    // ===================== DELETE (Soft Delete) =====================

    @Test
    @Order(3)
    @DisplayName("delete() - Soft delete (ẩn khách hàng)")
    void testDelete_SoftDelete() throws Exception {
        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(), any(), any()))
                    .thenReturn(1);

            int result = customerDAO.delete(1);
            assertEquals(1, result);
        }
    }

    // ===================== FIND ALL =====================

    @Test
    @Order(4)
    @DisplayName("findAll() - Trả về danh sách khách hàng")
    void testFindAll() throws Exception {
        ResultSet rs = mock(ResultSet.class);
        when(rs.next()).thenReturn(true, true, false);
        when(rs.getInt("id")).thenReturn(1, 2);
        when(rs.getString("fullname")).thenReturn("KH A", "KH B");
        when(rs.getString("phone")).thenReturn("0901111111", "0902222222");
        when(rs.getString("email")).thenReturn("a@t.com", "b@t.com");
        when(rs.getInt("point")).thenReturn(0, 50);
        when(rs.getBoolean("status")).thenReturn(true, true);
        when(rs.getDate("created_at")).thenReturn(Date.valueOf("2024-01-01"));

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString())).thenReturn(rs);

            List<Customer> list = customerDAO.findAll();
            assertEquals(2, list.size());
        }
    }

    // ===================== FIND BY ID =====================

    @Test
    @Order(5)
    @DisplayName("findById() - Tìm thấy khách hàng theo id")
    void testFindById_Found() throws Exception {
        ResultSet rs = mockCustomerRs(1, "KH A", "0901111111", 100, true);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), eq(1))).thenReturn(rs);

            Customer c = customerDAO.findById(1);
            assertNotNull(c);
            assertEquals(1, c.getId());
            assertEquals("KH A", c.getFullName());
        }
    }

    @Test
    @Order(6)
    @DisplayName("findById() - Không tìm thấy trả về null")
    void testFindById_NotFound() throws Exception {
        ResultSet rs = mock(ResultSet.class);
        when(rs.next()).thenReturn(false);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), eq(999))).thenReturn(rs);

            Customer c = customerDAO.findById(999);
            assertNull(c);
        }
    }

    // ===================== FIND BY PHONE =====================

    @Test
    @Order(7)
    @DisplayName("findByPhone() - Tìm khách hàng theo số điện thoại")
    void testFindByPhone_Found() throws Exception {
        ResultSet rs = mockCustomerRs(1, "KH A", "0901111111", 0, true);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), eq("0901111111"))).thenReturn(rs);

            Customer c = customerDAO.findByPhone("0901111111");
            assertNotNull(c);
            assertEquals("0901111111", c.getPhone());
        }
    }

    @Test
    @Order(8)
    @DisplayName("findByPhone() - Số điện thoại không tồn tại trả về null")
    void testFindByPhone_NotFound() throws Exception {
        ResultSet rs = mock(ResultSet.class);
        when(rs.next()).thenReturn(false);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), eq("0900000000"))).thenReturn(rs);

            Customer c = customerDAO.findByPhone("0900000000");
            assertNull(c);
        }
    }

    // ===================== UPDATE POINT =====================

    @Test
    @Order(9)
    @DisplayName("updatePoint() - Cập nhật điểm thành công")
    void testUpdatePoint_Success() throws Exception {
        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(), eq(200), eq(1)))
                    .thenReturn(1);

            int result = customerDAO.updatePoint(1, 200);
            assertEquals(1, result);
        }
    }

    // ===================== ADD POINT =====================

    @Test
    @Order(10)
    @DisplayName("addPoint() - Cộng điểm thành công")
    void testAddPoint_Success() throws Exception {
        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(), eq(50), eq(1)))
                    .thenReturn(1);

            int result = customerDAO.addPoint(1, 50);
            assertEquals(1, result);
        }
    }

    // ===================== DEDUCT POINT =====================

    @Test
    @Order(11)
    @DisplayName("deductPoint() - Trừ điểm thành công (đủ điểm)")
    void testDeductPoint_EnoughPoint() throws Exception {
        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            // SQL có điều kiện point >= deductPoint → trả về 1 nếu đủ điểm
            mock.when(() -> JdbcUtil.executeUpdate(anyString(), eq(30), eq(1), eq(30)))
                    .thenReturn(1);

            int result = customerDAO.deductPoint(1, 30);
            assertEquals(1, result);
        }
    }

    @Test
    @Order(12)
    @DisplayName("deductPoint() - Trừ điểm thất bại (không đủ điểm)")
    void testDeductPoint_NotEnoughPoint() throws Exception {
        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            // Không đủ điểm → SQL WHERE point >= ? không thỏa → 0 rows affected
            mock.when(() -> JdbcUtil.executeUpdate(anyString(), eq(1000), eq(1), eq(1000)))
                    .thenReturn(0);

            int result = customerDAO.deductPoint(1, 1000);
            assertEquals(0, result);
        }
    }

    // ===================== UPDATE STATUS =====================

    @Test
    @Order(13)
    @DisplayName("updateStatus() - Kích hoạt khách hàng")
    void testUpdateStatus_Activate() throws Exception {
        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(), eq(true), eq(1)))
                    .thenReturn(1);

            int result = customerDAO.updateStatus(1, true);
            assertEquals(1, result);
        }
    }

    @Test
    @Order(14)
    @DisplayName("updateStatus() - Khóa khách hàng")
    void testUpdateStatus_Deactivate() throws Exception {
        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(), eq(false), eq(1)))
                    .thenReturn(1);

            int result = customerDAO.updateStatus(1, false);
            assertEquals(1, result);
        }
    }
}
