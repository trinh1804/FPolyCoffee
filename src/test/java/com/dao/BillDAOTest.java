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
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.Date;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.persistence.Query;
import javax.persistence.TypedQuery;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;
import org.mockito.MockedStatic;

import com.entity.Bill;
import com.util.JpaUtil;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class BillDAOTest {

    private BillDAO billDAO;
    private EntityManager mockEm;
    private EntityTransaction mockTransaction;

    @BeforeEach
    void setUp() {
        billDAO = new BillDAO();
        mockEm = mock(EntityManager.class);
        mockTransaction = mock(EntityTransaction.class);

        when(mockEm.getTransaction()).thenReturn(mockTransaction);
        when(mockTransaction.isActive()).thenReturn(true);
    }

    @Test
    @Order(1)
    @DisplayName("create() - Thêm hóa đơn mới thành công")
    void testCreate_Success() throws Exception {
        Bill bill = new Bill();
        bill.setCreatedAt(new Date());
        bill.setTotalPrice(100000);
        bill.setDiscountAmount(0);
        bill.setPaymentMethod(false);
        bill.setStatus(0);
        bill.setCode("BILL-001");
        bill.setUserId(1);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);

            int result = billDAO.create(bill);
            assertEquals(1, result);
            verify(mockEm).persist(bill);
            verify(mockTransaction).commit();
        }
    }

    @Test
    @Order(2)
    @DisplayName("create() - Lỗi khi persist trả về 0")
    void testCreate_Exception() throws Exception {
        Bill bill = new Bill();
        bill.setCreatedAt(new Date());
        bill.setCode("BILL-001");

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            doThrow(new RuntimeException("DB error")).when(mockEm).persist(any());

            int result = billDAO.create(bill);
            assertEquals(0, result);
        }
    }

    @Test
    @Order(3)
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

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.merge(bill)).thenReturn(bill);

            int result = billDAO.update(bill);
            assertEquals(1, result);
        }
    }

    @Test
    @Order(4)
    @DisplayName("findAll() - Trả về danh sách hóa đơn")
    void testFindAll() throws Exception {
        @SuppressWarnings("unchecked")
        TypedQuery<Bill> mockQuery = mock(TypedQuery.class);
        Bill bill = new Bill();
        bill.setId(1);
        bill.setCode("BILL-001");
        List<Bill> expectedList = List.of(bill);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString(), eq(Bill.class))).thenReturn(mockQuery);
            when(mockQuery.getResultList()).thenReturn(expectedList);

            List<Bill> list = billDAO.findAll();
            assertEquals(1, list.size());
        }
    }

    @Test
    @Order(5)
    @DisplayName("findById() - Tìm thấy hóa đơn")
    void testFindById_Found() throws Exception {
        Bill expected = new Bill();
        expected.setId(1);
        expected.setCode("BILL-001");

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.find(Bill.class, 1)).thenReturn(expected);

            Bill bill = billDAO.findById(1);
            assertNotNull(bill);
            assertEquals("BILL-001", bill.getCode());
        }
    }

    @Test
    @Order(6)
    @DisplayName("findById() - Không tìm thấy trả về null")
    void testFindById_NotFound() throws Exception {
        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.find(Bill.class, 999)).thenReturn(null);

            Bill bill = billDAO.findById(999);
            assertNull(bill);
        }
    }

    @Test
    @Order(7)
    @DisplayName("updateStatus() - Chuyển từ waiting → finish hợp lệ")
    void testUpdateStatus_WaitingToFinish() throws Exception {
        Bill bill = new Bill();
        bill.setId(1);
        bill.setStatus(Bill.STATUS_WAITING);

        // UPDATE dùng single-arg createQuery → trả về Query (không phải TypedQuery)
        Query mockQuery = mock(Query.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.find(Bill.class, 1)).thenReturn(bill);
            when(mockEm.createQuery(anyString())).thenReturn(mockQuery);
            when(mockQuery.setParameter(1, Bill.STATUS_FINISH)).thenReturn(mockQuery);
            when(mockQuery.setParameter(2, 1)).thenReturn(mockQuery);
            when(mockQuery.executeUpdate()).thenReturn(1);

            int result = billDAO.updateStatus(1, Bill.STATUS_FINISH);
            assertEquals(1, result);
        }
    }

    @Test
    @Order(8)
    @DisplayName("updateStatus() - Chuyển từ waiting → cancel hợp lệ")
    void testUpdateStatus_WaitingToCancel() throws Exception {
        Bill bill = new Bill();
        bill.setId(1);
        bill.setStatus(Bill.STATUS_WAITING);

        Query mockQuery = mock(Query.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.find(Bill.class, 1)).thenReturn(bill);
            when(mockEm.createQuery(anyString())).thenReturn(mockQuery);
            when(mockQuery.setParameter(1, Bill.STATUS_CANCEL)).thenReturn(mockQuery);
            when(mockQuery.setParameter(2, 1)).thenReturn(mockQuery);
            when(mockQuery.executeUpdate()).thenReturn(1);

            int result = billDAO.updateStatus(1, Bill.STATUS_CANCEL);
            assertEquals(1, result);
        }
    }

    @Test
    @Order(9)
    @DisplayName("updateStatus() - Chuyển trạng thái không hợp lệ (finish → waiting) trả về 0")
    void testUpdateStatus_InvalidTransition() throws Exception {
        Bill bill = new Bill();
        bill.setId(1);
        bill.setStatus(Bill.STATUS_FINISH);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.find(Bill.class, 1)).thenReturn(bill);

            int result = billDAO.updateStatus(1, Bill.STATUS_WAITING);
            assertEquals(0, result);
            verify(mockEm, never()).createQuery(anyString());
        }
    }

    @Test
    @Order(10)
    @DisplayName("updateStatus() - Bill không tồn tại trả về 0")
    void testUpdateStatus_BillNotFound() throws Exception {
        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.find(Bill.class, 999)).thenReturn(null);

            int result = billDAO.updateStatus(999, Bill.STATUS_FINISH);
            assertEquals(0, result);
        }
    }

    @Test
    @Order(11)
    @DisplayName("applyDiscount() - Áp mã giảm giá vào bill đang chờ")
    void testApplyDiscount_Success() throws Exception {
        // UPDATE dùng single-arg createQuery
        Query mockQuery = mock(Query.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString())).thenReturn(mockQuery);
            when(mockQuery.setParameter(1, 1)).thenReturn(mockQuery);
            when(mockQuery.setParameter(2, 10000.0)).thenReturn(mockQuery);
            when(mockQuery.setParameter(3, 1)).thenReturn(mockQuery);
            when(mockQuery.executeUpdate()).thenReturn(1);

            int result = billDAO.applyDiscount(1, 1, 10000.0);
            assertEquals(1, result);
        }
    }

    @Test
    @Order(12)
    @DisplayName("assignCustomer() - Gán khách hàng vào bill")
    void testAssignCustomer_Success() throws Exception {
        // UPDATE dùng single-arg createQuery
        Query mockQuery = mock(Query.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString())).thenReturn(mockQuery);
            when(mockQuery.setParameter(1, 5)).thenReturn(mockQuery);
            when(mockQuery.setParameter(2, 1)).thenReturn(mockQuery);
            when(mockQuery.executeUpdate()).thenReturn(1);

            int result = billDAO.assignCustomer(1, 5);
            assertEquals(1, result);
        }
    }

    @Test
    @Order(13)
    @DisplayName("getTotalRevenueByDateRange() - Tổng doanh thu đúng")
    void testGetTotalRevenue() throws Exception {
        // SELECT COALESCE dùng createQuery(jpql, Double.class) → TypedQuery<Double>
        @SuppressWarnings("unchecked")
        TypedQuery<Double> mockQuery = mock(TypedQuery.class);
        Date from = new Date();
        Date to = new Date();

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString(), eq(Double.class))).thenReturn(mockQuery);
            when(mockQuery.setParameter(1, from)).thenReturn(mockQuery);
            when(mockQuery.setParameter(2, to)).thenReturn(mockQuery);
            when(mockQuery.getSingleResult()).thenReturn(500000.0);

            double revenue = billDAO.getTotalRevenueByDateRange(from, to);
            assertEquals(500000.0, revenue, 0.01);
        }
    }
}
