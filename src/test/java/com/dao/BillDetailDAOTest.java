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
import javax.persistence.Query;
import javax.persistence.TypedQuery;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;
import org.mockito.MockedStatic;

import com.entity.BillDetail;
import com.entity.BillDetailId;
import com.entity.Drink;
import com.util.JpaUtil;

/**
 * Unit test cho BillDetailDAO
 */
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class BillDetailDAOTest {

    private BillDetailDAO billDetailDAO;
    private EntityManager mockEm;
    private EntityTransaction mockTransaction;

    @BeforeEach
    void setUp() {
        billDetailDAO = new BillDetailDAO();
        mockEm = mock(EntityManager.class);
        mockTransaction = mock(EntityTransaction.class);

        when(mockEm.getTransaction()).thenReturn(mockTransaction);
        when(mockTransaction.isActive()).thenReturn(true);
    }

    @Test
    @Order(1)
    @DisplayName("create() - Thêm chi tiết hóa đơn thành công, tự tính total_price")
    void testCreate_AutoCalcTotalPrice() throws Exception {
        BillDetail detail = new BillDetail(1, 2, 3, 25000.0, 0);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);

            int result = billDetailDAO.create(detail);
            assertEquals(1, result);
            assertEquals(75000.0, detail.getTotalPrice(), 0.01);
            verify(mockEm).persist(detail);
            verify(mockTransaction).commit();
        }
    }

    @Test
    @Order(2)
    @DisplayName("create() - Lỗi khi persist trả về 0")
    void testCreate_Exception() throws Exception {
        BillDetail detail = new BillDetail(1, 2, 3, 25000.0, 0);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            doThrow(new RuntimeException("DB error")).when(mockEm).persist(any());

            int result = billDetailDAO.create(detail);
            assertEquals(0, result);
        }
    }

    @Test
    @Order(3)
    @DisplayName("update() - Cập nhật số lượng, tự tính lại total_price")
    void testUpdate_RecalcTotalPrice() throws Exception {
        BillDetail detail = new BillDetail(1, 2, 5, 25000.0, 0);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.merge(detail)).thenReturn(detail);

            int result = billDetailDAO.update(detail);
            assertEquals(1, result);
            assertEquals(125000.0, detail.getTotalPrice(), 0.01);
        }
    }

    @Test
    @Order(4)
    @DisplayName("deleteByBillAndDrink() - Xóa chi tiết theo bill và drink")
    void testDeleteByBillAndDrink_Success() throws Exception {
        // DELETE dùng single-arg createQuery → trả về Query
        Query mockQuery = mock(Query.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString())).thenReturn(mockQuery);
            when(mockQuery.setParameter(1, 1)).thenReturn(mockQuery);
            when(mockQuery.setParameter(2, 2)).thenReturn(mockQuery);
            when(mockQuery.executeUpdate()).thenReturn(1);

            int result = billDetailDAO.deleteByBillAndDrink(1, 2);
            assertEquals(1, result);
        }
    }

    @Test
    @Order(5)
    @DisplayName("deleteByBillId() - Xóa tất cả chi tiết của một hóa đơn")
    void testDeleteByBillId_Success() throws Exception {
        // DELETE dùng single-arg createQuery → trả về Query
        Query mockQuery = mock(Query.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString())).thenReturn(mockQuery);
            when(mockQuery.setParameter(1, 1)).thenReturn(mockQuery);
            when(mockQuery.executeUpdate()).thenReturn(3);

            int result = billDetailDAO.deleteByBillId(1);
            assertEquals(3, result);
        }
    }

    @Test
    @Order(6)
    @DisplayName("findByBillId() - Trả về danh sách chi tiết theo hóa đơn")
    void testFindByBillId_ReturnsList() throws Exception {
        // SELECT dùng createQuery(jpql, BillDetail.class) → TypedQuery<BillDetail>
        @SuppressWarnings("unchecked")
        TypedQuery<BillDetail> mockQuery = mock(TypedQuery.class);
        List<BillDetail> expectedList = List.of(
                new BillDetail(1, 1, 2, 25000.0, 50000.0),
                new BillDetail(1, 2, 1, 30000.0, 30000.0));

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString(), eq(BillDetail.class))).thenReturn(mockQuery);
            when(mockQuery.setParameter(1, 1)).thenReturn(mockQuery);
            when(mockQuery.getResultList()).thenReturn(expectedList);

            List<BillDetail> list = billDetailDAO.findByBillId(1);
            assertEquals(2, list.size());
            assertEquals(1, list.get(0).getBillId());
        }
    }

    @Test
    @Order(7)
    @DisplayName("findByBillId() - Hóa đơn không có chi tiết trả về rỗng")
    void testFindByBillId_Empty() throws Exception {
        @SuppressWarnings("unchecked")
        TypedQuery<BillDetail> mockQuery = mock(TypedQuery.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString(), eq(BillDetail.class))).thenReturn(mockQuery);
            when(mockQuery.setParameter(1, 99)).thenReturn(mockQuery);
            when(mockQuery.getResultList()).thenReturn(List.of());

            List<BillDetail> list = billDetailDAO.findByBillId(99);
            assertTrue(list.isEmpty());
        }
    }

    @Test
    @Order(8)
    @DisplayName("findByBillAndDrink() - Tìm thấy chi tiết theo bill+drink")
    void testFindByBillAndDrink_Found() throws Exception {
        BillDetail expected = new BillDetail(1, 2, 3, 25000.0, 75000.0);
        BillDetailId id = new BillDetailId(1, 2);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.find(BillDetail.class, id)).thenReturn(expected);

            BillDetail detail = billDetailDAO.findByBillAndDrink(1, 2);
            assertNotNull(detail);
            assertEquals(3, detail.getQuantity());
        }
    }

    @Test
    @Order(9)
    @DisplayName("findByBillAndDrink() - Không tìm thấy trả về null")
    void testFindByBillAndDrink_NotFound() throws Exception {
        BillDetailId id = new BillDetailId(1, 99);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.find(BillDetail.class, id)).thenReturn(null);

            BillDetail detail = billDetailDAO.findByBillAndDrink(1, 99);
            assertNull(detail);
        }
    }

    @Test
    @Order(10)
    @DisplayName("addDrinkToBill() - Thêm đồ uống mới vào bill")
    void testAddDrinkToBill_NewDrink() throws Exception {
        Drink drink = new Drink(2, "Cafe", 25000, "", "", true, 1);
        BillDetailId id = new BillDetailId(1, 2);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            // findByBillAndDrink → em.find(BillDetail.class, id)
            when(mockEm.find(BillDetail.class, id)).thenReturn(null);
            // drinkDAO.findById → em.find(Drink.class, id) (KHÔNG phải createQuery)
            when(mockEm.find(Drink.class, 2)).thenReturn(drink);

            int result = billDetailDAO.addDrinkToBill(1, 2);
            assertEquals(1, result);
            verify(mockEm).persist(any(BillDetail.class));
        }
    }

    @Test
    @Order(11)
    @DisplayName("updateQuantity() - Cập nhật số lượng > 0")
    void testUpdateQuantity_Positive() throws Exception {
        BillDetail existing = new BillDetail(1, 2, 3, 25000.0, 75000.0);
        BillDetailId id = new BillDetailId(1, 2);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.find(BillDetail.class, id)).thenReturn(existing);
            when(mockEm.merge(existing)).thenReturn(existing);

            int result = billDetailDAO.updateQuantity(1, 2, 5);
            assertEquals(1, result);
            assertEquals(125000.0, existing.getTotalPrice(), 0.01);
        }
    }

    @Test
    @Order(12)
    @DisplayName("updateQuantity() - Số lượng <= 0 → tự động xóa dòng đó")
    void testUpdateQuantity_ZeroAutoDelete() throws Exception {
        // Gọi deleteByBillAndDrink → DELETE single-arg createQuery
        Query mockQuery = mock(Query.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString())).thenReturn(mockQuery);
            when(mockQuery.setParameter(1, 1)).thenReturn(mockQuery);
            when(mockQuery.setParameter(2, 2)).thenReturn(mockQuery);
            when(mockQuery.executeUpdate()).thenReturn(1);

            int result = billDetailDAO.updateQuantity(1, 2, 0);
            assertEquals(1, result);
        }
    }
}
