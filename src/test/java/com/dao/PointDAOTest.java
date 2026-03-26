package com.dao;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
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

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;
import org.mockito.MockedStatic;

import com.entity.PointTransaction;
import com.util.JpaUtil;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class PointDAOTest {

    private PointDAO pointDAO;
    private EntityManager mockEm;
    private EntityTransaction mockTransaction;

    @BeforeEach
    void setUp() {
        pointDAO = new PointDAO();
        mockEm = mock(EntityManager.class);
        mockTransaction = mock(EntityTransaction.class);

        when(mockEm.getTransaction()).thenReturn(mockTransaction);
        when(mockTransaction.isActive()).thenReturn(true);
    }

    @Test
    @Order(1)
    @DisplayName("create() - Ghi giao dịch điểm thành công")
    void testCreate_Success() throws Exception {
        PointTransaction p = new PointTransaction(null, 10, 0,
                new Date(), "Tich diem hoa don #1", 1, 1);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);

            int result = pointDAO.create(p);
            assertEquals(1, result);
            verify(mockEm).persist(p);
            verify(mockTransaction).commit();
        }
    }

    @Test
    @Order(2)
    @DisplayName("create() - Lỗi khi persist trả về 0")
    void testCreate_Exception() throws Exception {
        PointTransaction p = new PointTransaction(null, 10, 0,
                new Date(), "Tich diem hoa don #1", 1, 1);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            doThrow(new RuntimeException("DB error")).when(mockEm).persist(any());

            int result = pointDAO.create(p);
            assertEquals(0, result);
        }
    }

    @Test
    @Order(3)
    @DisplayName("findAll() - Trả về lịch sử điểm")
    void testFindAll() throws Exception {
        @SuppressWarnings("unchecked")
        TypedQuery<PointTransaction> mockQuery = mock(TypedQuery.class);
        List<PointTransaction> expectedList = List.of(
                new PointTransaction(1, 10, 0, new Date(), "note", 1, 1));

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString(), eq(PointTransaction.class))).thenReturn(mockQuery);
            when(mockQuery.getResultList()).thenReturn(expectedList);

            List<PointTransaction> list = pointDAO.findAll();
            assertEquals(1, list.size());
        }
    }

    @Test
    @Order(4)
    @DisplayName("findByCustomerId() - Lịch sử điểm của khách hàng")
    void testFindByCustomerId() throws Exception {
        @SuppressWarnings("unchecked")
        TypedQuery<PointTransaction> mockQuery = mock(TypedQuery.class);
        List<PointTransaction> expectedList = List.of(
                new PointTransaction(1, 10, 0, new Date(), "note", 1, 1));

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString(), eq(PointTransaction.class))).thenReturn(mockQuery);
            when(mockQuery.setParameter(1, 1)).thenReturn(mockQuery);
            when(mockQuery.getResultList()).thenReturn(expectedList);

            List<PointTransaction> list = pointDAO.findByCustomerId(1);
            assertEquals(1, list.size());
            assertEquals(10, list.get(0).getBonusPoint());
        }
    }

    @Test
    @Order(5)
    @DisplayName("findByCustomerId() - Khách chưa có lịch sử trả về rỗng")
    void testFindByCustomerId_Empty() throws Exception {
        @SuppressWarnings("unchecked")
        TypedQuery<PointTransaction> mockQuery = mock(TypedQuery.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString(), eq(PointTransaction.class))).thenReturn(mockQuery);
            when(mockQuery.setParameter(1, 99)).thenReturn(mockQuery);
            when(mockQuery.getResultList()).thenReturn(List.of());

            List<PointTransaction> list = pointDAO.findByCustomerId(99);
            assertTrue(list.isEmpty());
        }
    }

    @Test
    @Order(6)
    @DisplayName("findByBillId() - Lấy giao dịch điểm theo hóa đơn")
    void testFindByBillId_Found() throws Exception {
        PointTransaction expected = new PointTransaction(1, 5, 0, new Date(), "note", 1, 1);
        @SuppressWarnings("unchecked")
        TypedQuery<PointTransaction> mockQuery = mock(TypedQuery.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString(), eq(PointTransaction.class))).thenReturn(mockQuery);
            when(mockQuery.setParameter(1, 1)).thenReturn(mockQuery);
            when(mockQuery.getSingleResult()).thenReturn(expected);

            PointTransaction p = pointDAO.findByBillId(1);
            assertNotNull(p);
            assertEquals(1, p.getBillId());
        }
    }

    @Test
    @Order(7)
    @DisplayName("calcBonusPoint() - 10,000 VNĐ = 1 điểm")
    void testCalcBonusPoint_Standard() {
        int points = pointDAO.calcBonusPoint(50000);
        assertEquals(5, points);
    }

    @Test
    @Order(8)
    @DisplayName("calcBonusPoint() - Số tiền không tròn → làm tròn xuống")
    void testCalcBonusPoint_Truncate() {
        int points = pointDAO.calcBonusPoint(55999);
        assertEquals(5, points);
    }

    @Test
    @Order(9)
    @DisplayName("calcBonusPoint() - Dưới 10,000 VNĐ = 0 điểm")
    void testCalcBonusPoint_BelowThreshold() {
        int points = pointDAO.calcBonusPoint(9999);
        assertEquals(0, points);
    }

    @Test
    @Order(10)
    @DisplayName("update() - Luôn trả về 0 (lịch sử không chỉnh sửa)")
    void testUpdate_AlwaysZero() {
        PointTransaction p = new PointTransaction(1, 10, 0, new Date(), "note", 1, 1);
        int result = pointDAO.update(p);
        assertEquals(0, result);
    }

    @Test
    @Order(11)
    @DisplayName("delete() - Luôn trả về 0 (lịch sử không xóa)")
    void testDelete_AlwaysZero() {
        int result = pointDAO.delete(1);
        assertEquals(0, result);
    }

    @Test
    @Order(12)
    @DisplayName("Hằng số AMOUNT_PER_POINT phải là 10,000")
    void testConstant_AmountPerPoint() {
        assertEquals(10_000.0, PointDAO.AMOUNT_PER_POINT, 0.01);
    }

    @Test
    @Order(13)
    @DisplayName("Hằng số POINT_VALUE phải là 1,000")
    void testConstant_PointValue() {
        assertEquals(1_000.0, PointDAO.POINT_VALUE, 0.01);
    }
}