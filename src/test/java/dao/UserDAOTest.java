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

import java.sql.ResultSet;
import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;
import org.mockito.MockedStatic;

import entity.User;
import util.JdbcUtil;

/**
 * Unit test cho UserDAO
 * Mock JdbcUtil để không cần kết nối database thật
 */
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class UserDAOTest {

    private UserDAO userDAO;

    @BeforeEach
    void setUp() {
        userDAO = new UserDAO();
    }

    // ===================== CREATE =====================

    @Test
    @Order(1)
    @DisplayName("create() - Thêm user thành công trả về 1")
    void testCreate_Success() throws Exception {
        User user = new User(0, "Nguyen Van A", "test@gmail.com",
                "0901234567", "password123", true, 2);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(),
                    any(), any(), any(), any(), any(), any()))
                    .thenReturn(1);

            int result = userDAO.create(user);
            assertEquals(1, result, "Tạo user thành công phải trả về 1");
        }
    }

    @Test
    @Order(2)
    @DisplayName("create() - Lỗi SQL trả về 0")
    void testCreate_SqlException() throws Exception {
        User user = new User(0, "Nguyen Van B", "dup@gmail.com",
                "0901111111", "pass", true, 2);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(), any()))
                    .thenThrow(new RuntimeException("Duplicate email"));

            int result = userDAO.create(user);
            assertEquals(0, result, "Lỗi SQL phải trả về 0");
        }
    }

    // ===================== UPDATE =====================

    @Test
    @Order(3)
    @DisplayName("update() - Cập nhật user thành công trả về 1")
    void testUpdate_Success() throws Exception {
        User user = new User(1, "Nguyen Van C", "update@gmail.com",
                "0909999999", "newpass", true, 2);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(),
                    any(), any(), any(), any(), any(), any(), any()))
                    .thenReturn(1);

            int result = userDAO.update(user);
            assertEquals(1, result);
        }
    }

    // ===================== DELETE (Soft Delete) =====================

    @Test
    @Order(4)
    @DisplayName("delete() - Soft delete (khóa tài khoản) trả về 1")
    void testDelete_SoftDelete() throws Exception {
        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(), any(), any()))
                    .thenReturn(1);

            int result = userDAO.delete(1);
            assertEquals(1, result, "Soft delete phải trả về 1");
        }
    }

    // ===================== FIND ALL =====================

    @Test
    @Order(5)
    @DisplayName("findAll() - Trả về danh sách user")
    void testFindAll_ReturnsList() throws Exception {
        ResultSet mockRs = mock(ResultSet.class);

        when(mockRs.next()).thenReturn(true, true, false); // 2 rows
        when(mockRs.getInt("id")).thenReturn(1, 2);
        when(mockRs.getString("fullname")).thenReturn("Admin", "Nhan vien");
        when(mockRs.getString("email")).thenReturn("admin@gmail.com", "nv@gmail.com");
        when(mockRs.getString("phone")).thenReturn("0911111111", "0922222222");
        when(mockRs.getString("password")).thenReturn("123456", "123456");
        when(mockRs.getBoolean("status")).thenReturn(true, true);
        when(mockRs.getInt("role_id")).thenReturn(1, 2);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString())).thenReturn(mockRs);

            List<User> list = userDAO.findAll();
            assertEquals(2, list.size());
            assertEquals("Admin", list.get(0).getFullName());
        }
    }

    @Test
    @Order(6)
    @DisplayName("findAll() - Không có dữ liệu trả về danh sách rỗng")
    void testFindAll_Empty() throws Exception {
        ResultSet mockRs = mock(ResultSet.class);
        when(mockRs.next()).thenReturn(false);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString())).thenReturn(mockRs);

            List<User> list = userDAO.findAll();
            assertTrue(list.isEmpty());
        }
    }

    // ===================== FIND BY ID =====================

    @Test
    @Order(7)
    @DisplayName("findById() - Tìm thấy user trả về đúng object")
    void testFindById_Found() throws Exception {
        ResultSet mockRs = mock(ResultSet.class);
        when(mockRs.next()).thenReturn(true, false);
        when(mockRs.getInt("id")).thenReturn(1);
        when(mockRs.getString("fullname")).thenReturn("Admin");
        when(mockRs.getString("email")).thenReturn("admin@gmail.com");
        when(mockRs.getString("phone")).thenReturn("0919123123");
        when(mockRs.getString("password")).thenReturn("123456");
        when(mockRs.getBoolean("status")).thenReturn(true);
        when(mockRs.getInt("role_id")).thenReturn(1);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), eq(1))).thenReturn(mockRs);

            User user = userDAO.findById(1);
            assertNotNull(user);
            assertEquals(1, user.getId());
            assertEquals("admin@gmail.com", user.getEmail());
        }
    }

    @Test
    @Order(8)
    @DisplayName("findById() - Không tìm thấy trả về null")
    void testFindById_NotFound() throws Exception {
        ResultSet mockRs = mock(ResultSet.class);
        when(mockRs.next()).thenReturn(false);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), eq(999))).thenReturn(mockRs);

            User user = userDAO.findById(999);
            assertNull(user);
        }
    }

    // ===================== FIND BY EMAIL =====================

    @Test
    @Order(9)
    @DisplayName("findByEmail() - Tìm user đang hoạt động theo email")
    void testFindByEmail_ActiveUser() throws Exception {
        ResultSet mockRs = mock(ResultSet.class);
        when(mockRs.next()).thenReturn(true, false);
        when(mockRs.getInt("id")).thenReturn(1);
        when(mockRs.getString("fullname")).thenReturn("Admin");
        when(mockRs.getString("email")).thenReturn("admin@gmail.com");
        when(mockRs.getString("phone")).thenReturn("0919123123");
        when(mockRs.getString("password")).thenReturn("123456");
        when(mockRs.getBoolean("status")).thenReturn(true);
        when(mockRs.getInt("role_id")).thenReturn(1);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), eq("admin@gmail.com")))
                    .thenReturn(mockRs);

            User user = userDAO.findByEmail("admin@gmail.com");
            assertNotNull(user);
            assertTrue(user.isActive());
        }
    }

    @Test
    @Order(10)
    @DisplayName("findByEmail() - Email không tồn tại trả về null")
    void testFindByEmail_NotFound() throws Exception {
        ResultSet mockRs = mock(ResultSet.class);
        when(mockRs.next()).thenReturn(false);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), eq("ghost@gmail.com")))
                    .thenReturn(mockRs);

            User user = userDAO.findByEmail("ghost@gmail.com");
            assertNull(user);
        }
    }

    // ===================== UPDATE PASSWORD =====================

    @Test
    @Order(11)
    @DisplayName("updatePassword() - Đổi mật khẩu thành công")
    void testUpdatePassword_Success() throws Exception {
        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(), eq("newPass"), eq(1)))
                    .thenReturn(1);

            int result = userDAO.updatePassword(1, "newPass");
            assertEquals(1, result);
        }
    }

    // ===================== UPDATE STATUS =====================

    @Test
    @Order(12)
    @DisplayName("updateStatus() - Khóa tài khoản thành công")
    void testUpdateStatus_Lock() throws Exception {
        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(), eq(false), eq(1)))
                    .thenReturn(1);

            int result = userDAO.updateStatus(1, false);
            assertEquals(1, result);
        }
    }

    // ===================== FIND BY ROLE =====================

    @Test
    @Order(13)
    @DisplayName("findByRoleId() - Lấy danh sách nhân viên theo role")
    void testFindByRoleId_Returns() throws Exception {
        ResultSet mockRs = mock(ResultSet.class);
        when(mockRs.next()).thenReturn(true, false);
        when(mockRs.getInt("id")).thenReturn(2);
        when(mockRs.getString("fullname")).thenReturn("Nhan Vien A");
        when(mockRs.getString("email")).thenReturn("nva@gmail.com");
        when(mockRs.getString("phone")).thenReturn("0933333333");
        when(mockRs.getString("password")).thenReturn("123456");
        when(mockRs.getBoolean("status")).thenReturn(true);
        when(mockRs.getInt("role_id")).thenReturn(2);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), eq(2))).thenReturn(mockRs);

            List<User> list = userDAO.findByRoleId(2);
            assertEquals(1, list.size());
            assertEquals(2, list.get(0).getRoleId());
        }
    }
}