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

import java.util.Date;
import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;
import org.mockito.MockedStatic;

import com.entity.DiscountCode;
import com.util.JpaUtil;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class DiscountCodeDAOTest {

    private DiscountCodeDAO discountDAO;
    private EntityManager mockEm;
    private EntityTransaction mockTransaction;

    @BeforeEach
    void setUp() {
        discountDAO = new DiscountCodeDAO();
        mockEm = mock(EntityManager.class);
        mockTransaction = mock(EntityTransaction.class);

        when(mockEm.getTransaction()).thenReturn(mockTransaction);
        when(mockTransaction.isActive()).thenReturn(true);
    }

    @Test
    @Order(1)
    @DisplayName("create() - Thêm mã giảm giá cố định thành công")
    void testCreate_FixedDiscount() throws Exception {
        DiscountCode dc = new DiscountCode(null, "GIAM10K", 10000, false,
                new Date(), new Date(), true, "Giam 10k");

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);

            int result = discountDAO.create(dc);
            assertEquals(1, result);
            verify(mockEm).persist(dc);
            verify(mockTransaction).commit();
        }
    }

    @Test
    @Order(2)
    @DisplayName("create() - Thêm mã giảm giá phần trăm thành công")
    void testCreate_PercentDiscount() throws Exception {
        DiscountCode dc = new DiscountCode(null, "GIAM20P", 20, true,
                new Date(), new Date(), true, "Giam 20%");

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);

            int result = discountDAO.create(dc);
            assertEquals(1, result);
        }
    }

    @Test
    @Order(3)
    @DisplayName("create() - Lỗi khi persist trả về 0")
    void testCreate_Exception() throws Exception {
        DiscountCode dc = new DiscountCode(null, "GIAM10K", 10000, false,
                new Date(), new Date(), true, "Giam 10k");

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            doThrow(new RuntimeException("DB error")).when(mockEm).persist(any());

            int result = discountDAO.create(dc);
            assertEquals(0, result);
        }
    }

    @Test
    @Order(4)
    @DisplayName("update() - Cập nhật mã giảm giá thành công")
    void testUpdate_Success() throws Exception {
        DiscountCode dc = new DiscountCode(1, "GIAM10K", 15000, false,
                new Date(), new Date(), true, "Updated");

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.merge(dc)).thenReturn(dc);

            int result = discountDAO.update(dc);
            assertEquals(1, result);
        }
    }

    @Test
    @Order(5)
    @DisplayName("delete() - Xóa mã giảm giá thành công")
    void testDelete_Success() throws Exception {
        DiscountCode dc = new DiscountCode(1, "GIAM10K", 10000, false,
                new Date(), new Date(), true, "Giam 10k");

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.find(DiscountCode.class, 1)).thenReturn(dc);

            int result = discountDAO.delete(1);
            assertEquals(1, result);
            verify(mockEm).remove(dc);
        }
    }

    @Test
    @Order(6)
    @DisplayName("delete() - Xóa id không tồn tại trả về 1")
    void testDelete_NotFound() throws Exception {
        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.find(DiscountCode.class, 999)).thenReturn(null);

            int result = discountDAO.delete(999);
            assertEquals(1, result);
        }
    }

    @Test
    @Order(7)
    @DisplayName("findAll() - Trả về danh sách mã giảm giá")
    void testFindAll() throws Exception {
        @SuppressWarnings("unchecked")
        TypedQuery<DiscountCode> mockQuery = mock(TypedQuery.class);
        List<DiscountCode> expectedList = List.of(
                new DiscountCode(1, "GIAM10K", 10000, false, new Date(), new Date(), true, "dieu kien"));

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString(), eq(DiscountCode.class))).thenReturn(mockQuery);
            when(mockQuery.getResultList()).thenReturn(expectedList);

            List<DiscountCode> list = discountDAO.findAll();
            assertEquals(1, list.size());
            assertEquals("GIAM10K", list.get(0).getCode());
        }
    }

    @Test
    @Order(8)
    @DisplayName("findById() - Tìm thấy mã theo id")
    void testFindById_Found() throws Exception {
        DiscountCode expected = new DiscountCode(1, "GIAM10K", 10000, false,
                new Date(), new Date(), true, "dieu kien");

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.find(DiscountCode.class, 1)).thenReturn(expected);

            DiscountCode dc = discountDAO.findById(1);
            assertNotNull(dc);
            assertEquals("GIAM10K", dc.getCode());
        }
    }

    @Test
    @Order(9)
    @DisplayName("findById() - Không tìm thấy trả về null")
    void testFindById_NotFound() throws Exception {
        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.find(DiscountCode.class, 999)).thenReturn(null);

            DiscountCode dc = discountDAO.findById(999);
            assertNull(dc);
        }
    }

    @Test
    @Order(10)
    @DisplayName("findByCode() - Tìm mã còn hiệu lực")
    void testFindByCode_Valid() throws Exception {
        DiscountCode expected = new DiscountCode(1, "GIAM10K", 10000, false,
                new Date(), new Date(), true, "dieu kien");
        @SuppressWarnings("unchecked")
        TypedQuery<DiscountCode> mockQuery = mock(TypedQuery.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString(), eq(DiscountCode.class))).thenReturn(mockQuery);
            when(mockQuery.setParameter(eq(1), eq("GIAM10K"))).thenReturn(mockQuery);
            when(mockQuery.setParameter(eq(2), any(Date.class))).thenReturn(mockQuery);
            when(mockQuery.setParameter(eq(3), any(Date.class))).thenReturn(mockQuery);
            when(mockQuery.getSingleResult()).thenReturn(expected);

            DiscountCode dc = discountDAO.findByCode("GIAM10K");
            assertNotNull(dc);
            assertTrue(dc.isActive());
        }
    }

    @Test
    @Order(11)
    @DisplayName("findByCode() - Mã không tồn tại trả về null")
    void testFindByCode_NotFound() throws Exception {
        @SuppressWarnings("unchecked")
        TypedQuery<DiscountCode> mockQuery = mock(TypedQuery.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString(), eq(DiscountCode.class))).thenReturn(mockQuery);
            when(mockQuery.setParameter(eq(1), eq("HETHAN"))).thenReturn(mockQuery);
            when(mockQuery.setParameter(eq(2), any(Date.class))).thenReturn(mockQuery);
            when(mockQuery.setParameter(eq(3), any(Date.class))).thenReturn(mockQuery);
            when(mockQuery.getSingleResult()).thenThrow(new NoResultException());

            DiscountCode dc = discountDAO.findByCode("HETHAN");
            assertNull(dc);
        }
    }

    @Test
    @Order(12)
    @DisplayName("calculateDiscount() - Giảm giá cố định")
    void testCalcDiscount_Fixed() {
        DiscountCode dc = new DiscountCode(1, "CODE", 10000, false,
                new Date(), new Date(), true, "");

        double discount = discountDAO.calculateDiscount(dc, 50000);
        assertEquals(10000.0, discount, 0.01);
    }

    @Test
    @Order(13)
    @DisplayName("calculateDiscount() - Giảm giá cố định không vượt quá total")
    void testCalcDiscount_FixedCapAtTotal() {
        DiscountCode dc = new DiscountCode(1, "CODE", 100000, false,
                new Date(), new Date(), true, "");

        double discount = discountDAO.calculateDiscount(dc, 30000);
        assertEquals(30000.0, discount, 0.01);
    }

    @Test
    @Order(14)
    @DisplayName("calculateDiscount() - Giảm giá theo phần trăm")
    void testCalcDiscount_Percent() {
        DiscountCode dc = new DiscountCode(1, "CODE", 20, true,
                new Date(), new Date(), true, "");

        double discount = discountDAO.calculateDiscount(dc, 100000);
        assertEquals(20000.0, discount, 0.01);
    }

    @Test
    @Order(15)
    @DisplayName("calculateDiscount() - Mã null trả về 0")
    void testCalcDiscount_NullCode() {
        double discount = discountDAO.calculateDiscount(null, 100000);
        assertEquals(0.0, discount, 0.01);
    }
}