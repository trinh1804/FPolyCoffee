package com.dao;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockStatic;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.persistence.NoResultException;
import javax.persistence.Query;
import javax.persistence.TypedQuery;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;
import org.mockito.MockedStatic;

import com.entity.User;
import com.util.JpaUtil;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class UserDAOTest {

    private UserDAO userDAO;
    private EntityManager mockEm;
    private EntityTransaction mockTransaction;

    @BeforeEach
    void setUp() {
        userDAO = new UserDAO();
        mockEm = mock(EntityManager.class);
        mockTransaction = mock(EntityTransaction.class);

        when(mockEm.getTransaction()).thenReturn(mockTransaction);
        when(mockTransaction.isActive()).thenReturn(true);
    }

    @Test
    @Order(1)
    @DisplayName("create() - Thêm user thành công trả về 1")
    void testCreate_Success() throws Exception {
        User user = new User(null, "Nguyen Van A", "test@gmail.com",
                "0901234567", "password123", true, 2);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);

            int result = userDAO.create(user);
            assertEquals(1, result);
            verify(mockEm).persist(user);
            verify(mockTransaction).commit();
        }
    }

    @Test
    @Order(2)
    @DisplayName("create() - Lỗi SQL trả về 0")
    void testCreate_Exception() throws Exception {
        User user = new User(null, "Nguyen Van B", "dup@gmail.com",
                "0901111111", "pass", true, 2);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            doThrow(new RuntimeException("Duplicate email")).when(mockEm).persist(any());

            int result = userDAO.create(user);
            assertEquals(0, result);
        }
    }

    @Test
    @Order(3)
    @DisplayName("update() - Cập nhật user thành công trả về 1")
    void testUpdate_Success() throws Exception {
        User user = new User(1, "Nguyen Van C", "update@gmail.com",
                "0909999999", "newpass", true, 2);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.merge(user)).thenReturn(user);

            int result = userDAO.update(user);
            assertEquals(1, result);
        }
    }

    @Test
    @Order(4)
    @DisplayName("delete() - Soft delete (khóa tài khoản) trả về 1")
    void testDelete_SoftDelete() throws Exception {
        // delete() gọi updateStatus(id, false) → UPDATE single-arg createQuery
        Query mockQuery = mock(Query.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString())).thenReturn(mockQuery);
            when(mockQuery.setParameter(1, false)).thenReturn(mockQuery);
            when(mockQuery.setParameter(2, 1)).thenReturn(mockQuery);
            when(mockQuery.executeUpdate()).thenReturn(1);

            int result = userDAO.delete(1);
            assertEquals(1, result);
        }
    }

    @Test
    @Order(5)
    @DisplayName("findAll() - Trả về danh sách user")
    void testFindAll_ReturnsList() throws Exception {
        // SELECT dùng createQuery(jpql, User.class) → TypedQuery<User>
        @SuppressWarnings("unchecked")
        TypedQuery<User> mockQuery = mock(TypedQuery.class);
        List<User> expectedList = List.of(
                new User(1, "Admin", "admin@gmail.com", "0911111111", "123456", true, 1),
                new User(2, "Nhan vien", "nv@gmail.com", "0922222222", "123456", true, 2));

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString(), eq(User.class))).thenReturn(mockQuery);
            when(mockQuery.getResultList()).thenReturn(expectedList);

            List<User> list = userDAO.findAll();
            assertEquals(2, list.size());
            assertEquals("Admin", list.get(0).getFullName());
        }
    }

    @Test
    @Order(6)
    @DisplayName("findAll() - Không có dữ liệu trả về danh sách rỗng")
    void testFindAll_Empty() throws Exception {
        @SuppressWarnings("unchecked")
        TypedQuery<User> mockQuery = mock(TypedQuery.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString(), eq(User.class))).thenReturn(mockQuery);
            when(mockQuery.getResultList()).thenReturn(List.of());

            List<User> list = userDAO.findAll();
            assertTrue(list.isEmpty());
        }
    }

    @Test
    @Order(7)
    @DisplayName("findById() - Tìm thấy user trả về đúng object")
    void testFindById_Found() throws Exception {
        User expected = new User(1, "Admin", "admin@gmail.com", "0919123123", "123456", true, 1);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.find(User.class, 1)).thenReturn(expected);

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
        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.find(User.class, 999)).thenReturn(null);

            User user = userDAO.findById(999);
            assertNull(user);
        }
    }

    @Test
    @Order(9)
    @DisplayName("findByEmail() - Tìm user đang hoạt động theo email")
    void testFindByEmail_ActiveUser() throws Exception {
        User expected = new User(1, "Admin", "admin@gmail.com", "0919123123", "123456", true, 1);
        // SELECT dùng createQuery(jpql, User.class) → TypedQuery<User>
        @SuppressWarnings("unchecked")
        TypedQuery<User> mockQuery = mock(TypedQuery.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString(), eq(User.class))).thenReturn(mockQuery);
            when(mockQuery.setParameter(1, "admin@gmail.com")).thenReturn(mockQuery);
            when(mockQuery.getSingleResult()).thenReturn(expected);

            User user = userDAO.findByEmail("admin@gmail.com");
            assertNotNull(user);
            assertTrue(user.isActive());
        }
    }

    @Test
    @Order(10)
    @DisplayName("findByEmail() - Email không tồn tại trả về null")
    void testFindByEmail_NotFound() throws Exception {
        @SuppressWarnings("unchecked")
        TypedQuery<User> mockQuery = mock(TypedQuery.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString(), eq(User.class))).thenReturn(mockQuery);
            when(mockQuery.setParameter(1, "ghost@gmail.com")).thenReturn(mockQuery);
            when(mockQuery.getSingleResult()).thenThrow(new NoResultException());

            User user = userDAO.findByEmail("ghost@gmail.com");
            assertNull(user);
        }
    }

    @Test
    @Order(11)
    @DisplayName("updatePassword() - Đổi mật khẩu thành công")
    void testUpdatePassword_Success() throws Exception {
        // UPDATE single-arg createQuery → Query
        Query mockQuery = mock(Query.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString())).thenReturn(mockQuery);
            when(mockQuery.setParameter(1, "newPass")).thenReturn(mockQuery);
            when(mockQuery.setParameter(2, 1)).thenReturn(mockQuery);
            when(mockQuery.executeUpdate()).thenReturn(1);

            int result = userDAO.updatePassword(1, "newPass");
            assertEquals(1, result);
        }
    }

    @Test
    @Order(12)
    @DisplayName("updateStatus() - Khóa tài khoản thành công")
    void testUpdateStatus_Lock() throws Exception {
        // UPDATE single-arg createQuery → Query
        Query mockQuery = mock(Query.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString())).thenReturn(mockQuery);
            when(mockQuery.setParameter(1, false)).thenReturn(mockQuery);
            when(mockQuery.setParameter(2, 1)).thenReturn(mockQuery);
            when(mockQuery.executeUpdate()).thenReturn(1);

            int result = userDAO.updateStatus(1, false);
            assertEquals(1, result);
        }
    }

    @Test
    @Order(13)
    @DisplayName("findByRoleId() - Lấy danh sách nhân viên theo role")
    void testFindByRoleId_Returns() throws Exception {
        // SELECT dùng createQuery(jpql, User.class) → TypedQuery<User>
        @SuppressWarnings("unchecked")
        TypedQuery<User> mockQuery = mock(TypedQuery.class);
        List<User> expectedList = List.of(
                new User(2, "Nhan Vien A", "nva@gmail.com", "0933333333", "123456", true, 2));

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString(), eq(User.class))).thenReturn(mockQuery);
            when(mockQuery.setParameter(1, 2)).thenReturn(mockQuery);
            when(mockQuery.getResultList()).thenReturn(expectedList);

            List<User> list = userDAO.findByRoleId(2);
            assertEquals(1, list.size());
            assertEquals(2, list.get(0).getRoleId());
        }
    }
}
