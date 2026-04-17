package com.dao;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockStatic;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.Date;
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

import com.entity.Customer;
import com.util.JpaUtil;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class CustomerDAOTest {

    private CustomerDAO customerDAO;
    private EntityManager mockEm;
    private EntityTransaction mockTransaction;

    @BeforeEach
    void setUp() {
        customerDAO = new CustomerDAO();
        mockEm = mock(EntityManager.class);
        mockTransaction = mock(EntityTransaction.class);

        when(mockEm.getTransaction()).thenReturn(mockTransaction);
        when(mockTransaction.isActive()).thenReturn(true);
    }

    @Test
    @Order(1)
    @DisplayName("create() - Thêm khách hàng thành công")
    void testCreate_Success() throws Exception {
        Customer c = new Customer(null, "Nguyen Van A", "0901234567",
                "a@gmail.com", 0, true, new Date());

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);

            int result = customerDAO.create(c);
            assertEquals(1, result);
            verify(mockEm).persist(c);
            verify(mockTransaction).commit();
        }
    }

    @Test
    @Order(2)
    @DisplayName("create() - Lỗi SQL trả về 0")
    void testCreate_Exception() throws Exception {
        Customer c = new Customer(null, "Nguyen Van A", "0901234567",
                "a@gmail.com", 0, true, new Date());

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            doThrow(new RuntimeException("DB error")).when(mockEm).persist(any());

            int result = customerDAO.create(c);
            assertEquals(0, result);
            verify(mockTransaction).rollback();
        }
    }

    @Test
    @Order(3)
    @DisplayName("update() - Cập nhật thông tin khách hàng")
    void testUpdate_Success() throws Exception {
        Customer c = new Customer(1, "Nguyen Van B", "0902222222",
                "b@gmail.com", 100, true, new Date());

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.merge(c)).thenReturn(c);

            int result = customerDAO.update(c);
            assertEquals(1, result);
            verify(mockTransaction).commit();
        }
    }

    @Test
    @Order(4)
    @DisplayName("delete() - Soft delete (ẩn khách hàng)")
    void testDelete_SoftDelete() throws Exception {
        // delete() gọi updateStatus(id, false) → UPDATE single-arg createQuery
        Query mockQuery = mock(Query.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString())).thenReturn(mockQuery);
            when(mockQuery.setParameter(1, false)).thenReturn(mockQuery);
            when(mockQuery.setParameter(2, 1)).thenReturn(mockQuery);
            when(mockQuery.executeUpdate()).thenReturn(1);

            int result = customerDAO.delete(1);
            assertEquals(1, result);
        }
    }

    @Test
    @Order(5)
    @DisplayName("findAll() - Trả về danh sách khách hàng")
    void testFindAll() throws Exception {
        // SELECT dùng createQuery(jpql, Customer.class) → TypedQuery<Customer>
        @SuppressWarnings("unchecked")
        TypedQuery<Customer> mockQuery = mock(TypedQuery.class);
        List<Customer> expectedList = List.of(
                new Customer(1, "KH A", "0901111111", "a@t.com", 0, true, new Date()),
                new Customer(2, "KH B", "0902222222", "b@t.com", 50, true, new Date()));

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString(), eq(Customer.class))).thenReturn(mockQuery);
            when(mockQuery.getResultList()).thenReturn(expectedList);

            List<Customer> list = customerDAO.findAll();
            assertEquals(2, list.size());
        }
    }

    @Test
    @Order(6)
    @DisplayName("findById() - Tìm thấy khách hàng theo id")
    void testFindById_Found() throws Exception {
        Customer expected = new Customer(1, "KH A", "0901111111", "a@t.com", 100, true, new Date());

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.find(Customer.class, 1)).thenReturn(expected);

            Customer c = customerDAO.findById(1);
            assertNotNull(c);
            assertEquals(1, c.getId());
            assertEquals("KH A", c.getFullName());
        }
    }

    @Test
    @Order(7)
    @DisplayName("findById() - Không tìm thấy trả về null")
    void testFindById_NotFound() throws Exception {
        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.find(Customer.class, 999)).thenReturn(null);

            Customer c = customerDAO.findById(999);
            assertNull(c);
        }
    }

    @Test
    @Order(8)
    @DisplayName("findByPhone() - Tìm khách hàng theo số điện thoại")
    void testFindByPhone_Found() throws Exception {
        Customer expected = new Customer(1, "KH A", "0901111111", "a@t.com", 0, true, new Date());
        // SELECT dùng createQuery(jpql, Customer.class) → TypedQuery<Customer>
        @SuppressWarnings("unchecked")
        TypedQuery<Customer> mockQuery = mock(TypedQuery.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString(), eq(Customer.class))).thenReturn(mockQuery);
            when(mockQuery.setParameter(1, "0901111111")).thenReturn(mockQuery);
            when(mockQuery.getSingleResult()).thenReturn(expected);

            Customer c = customerDAO.findByPhone("0901111111");
            assertNotNull(c);
            assertEquals("0901111111", c.getPhone());
        }
    }

    @Test
    @Order(9)
    @DisplayName("findByPhone() - Số điện thoại không tồn tại trả về null")
    void testFindByPhone_NotFound() throws Exception {
        @SuppressWarnings("unchecked")
        TypedQuery<Customer> mockQuery = mock(TypedQuery.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString(), eq(Customer.class))).thenReturn(mockQuery);
            when(mockQuery.setParameter(1, "0900000000")).thenReturn(mockQuery);
            when(mockQuery.getSingleResult()).thenThrow(new NoResultException());

            Customer c = customerDAO.findByPhone("0900000000");
            assertNull(c);
        }
    }

    @Test
    @Order(10)
    @DisplayName("updatePoint() - Cập nhật điểm thành công")
    void testUpdatePoint_Success() throws Exception {
        // UPDATE single-arg createQuery → Query
        Query mockQuery = mock(Query.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString())).thenReturn(mockQuery);
            when(mockQuery.setParameter(1, 200)).thenReturn(mockQuery);
            when(mockQuery.setParameter(2, 1)).thenReturn(mockQuery);
            when(mockQuery.executeUpdate()).thenReturn(1);

            int result = customerDAO.updatePoint(1, 200);
            assertEquals(1, result);
        }
    }

    @Test
    @Order(11)
    @DisplayName("addPoint() - Cộng điểm thành công")
    void testAddPoint_Success() throws Exception {
        // UPDATE single-arg createQuery → Query
        Query mockQuery = mock(Query.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString())).thenReturn(mockQuery);
            when(mockQuery.setParameter(1, 50)).thenReturn(mockQuery);
            when(mockQuery.setParameter(2, 1)).thenReturn(mockQuery);
            when(mockQuery.executeUpdate()).thenReturn(1);

            int result = customerDAO.addPoint(1, 50);
            assertEquals(1, result);
        }
    }

    @Test
    @Order(12)
    @DisplayName("deductPoint() - Trừ điểm thành công (đủ điểm)")
    void testDeductPoint_EnoughPoint() throws Exception {
        // UPDATE single-arg createQuery → Query
        Query mockQuery = mock(Query.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString())).thenReturn(mockQuery);
            when(mockQuery.setParameter(1, 30)).thenReturn(mockQuery);
            when(mockQuery.setParameter(2, 1)).thenReturn(mockQuery);
            when(mockQuery.setParameter(3, 30)).thenReturn(mockQuery);
            when(mockQuery.executeUpdate()).thenReturn(1);

            int result = customerDAO.deductPoint(1, 30);
            assertEquals(1, result);
        }
    }

    @Test
    @Order(13)
    @DisplayName("deductPoint() - Trừ điểm thất bại (không đủ điểm)")
    void testDeductPoint_NotEnoughPoint() throws Exception {
        // UPDATE có điều kiện c.point >= deductPoint → không đủ điểm trả về 0 rows
        Query mockQuery = mock(Query.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString())).thenReturn(mockQuery);
            when(mockQuery.setParameter(1, 1000)).thenReturn(mockQuery);
            when(mockQuery.setParameter(2, 1)).thenReturn(mockQuery);
            when(mockQuery.setParameter(3, 1000)).thenReturn(mockQuery);
            when(mockQuery.executeUpdate()).thenReturn(0);

            int result = customerDAO.deductPoint(1, 1000);
            assertEquals(0, result);
        }
    }

    @Test
    @Order(14)
    @DisplayName("updateStatus() - Kích hoạt khách hàng")
    void testUpdateStatus_Activate() throws Exception {
        // UPDATE single-arg createQuery → Query
        Query mockQuery = mock(Query.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString())).thenReturn(mockQuery);
            when(mockQuery.setParameter(1, true)).thenReturn(mockQuery);
            when(mockQuery.setParameter(2, 1)).thenReturn(mockQuery);
            when(mockQuery.executeUpdate()).thenReturn(1);

            int result = customerDAO.updateStatus(1, true);
            assertEquals(1, result);
        }
    }

    @Test
    @Order(15)
    @DisplayName("updateStatus() - Khóa khách hàng")
    void testUpdateStatus_Deactivate() throws Exception {
        // UPDATE single-arg createQuery → Query
        Query mockQuery = mock(Query.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString())).thenReturn(mockQuery);
            when(mockQuery.setParameter(1, false)).thenReturn(mockQuery);
            when(mockQuery.setParameter(2, 1)).thenReturn(mockQuery);
            when(mockQuery.executeUpdate()).thenReturn(1);

            int result = customerDAO.updateStatus(1, false);
            assertEquals(1, result);
        }
    }
}
