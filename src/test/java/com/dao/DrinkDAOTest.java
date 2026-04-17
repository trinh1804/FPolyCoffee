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

import com.entity.Drink;
import com.util.JpaUtil;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class DrinkDAOTest {

    private DrinkDAO drinkDAO;
    private EntityManager mockEm;
    private EntityTransaction mockTransaction;

    @BeforeEach
    void setUp() {
        drinkDAO = new DrinkDAO();
        mockEm = mock(EntityManager.class);
        mockTransaction = mock(EntityTransaction.class);

        when(mockEm.getTransaction()).thenReturn(mockTransaction);
        when(mockTransaction.isActive()).thenReturn(true);
    }

    @Test
    @Order(1)
    @DisplayName("create() - Thêm đồ uống thành công")
    void testCreate_Success() throws Exception {
        Drink drink = new Drink(null, "Cafe Den", 25000, "Cafe den dac", "", true, 1);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);

            int result = drinkDAO.create(drink);
            assertEquals(1, result);
            verify(mockEm).persist(drink);
            verify(mockTransaction).commit();
        }
    }

    @Test
    @Order(2)
    @DisplayName("create() - Lỗi khi persist trả về 0")
    void testCreate_Fail() throws Exception {
        Drink drink = new Drink(null, "", 0, "", "", true, 1);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            doThrow(new RuntimeException("SQL error")).when(mockEm).persist(any());

            int result = drinkDAO.create(drink);
            assertEquals(0, result);
        }
    }

    @Test
    @Order(3)
    @DisplayName("update() - Cập nhật đồ uống thành công")
    void testUpdate_Success() throws Exception {
        Drink drink = new Drink(1, "Cafe Sua", 30000, "Cafe sua ngon", "", true, 1);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.merge(drink)).thenReturn(drink);

            int result = drinkDAO.update(drink);
            assertEquals(1, result);
        }
    }

    @Test
    @Order(4)
    @DisplayName("delete() - Xóa cứng đồ uống thành công")
    void testDelete_Success() throws Exception {
        Drink drink = new Drink(1, "Cafe Den", 25000, "", "", true, 1);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.find(Drink.class, 1)).thenReturn(drink);

            int result = drinkDAO.delete(1);
            assertEquals(1, result);
            verify(mockEm).remove(drink);
        }
    }

    @Test
    @Order(5)
    @DisplayName("softDelete() - Ẩn đồ uống (status=0) thành công")
    void testSoftDelete_Success() throws Exception {
        // UPDATE dùng single-arg createQuery → Query
        Query mockQuery = mock(Query.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString())).thenReturn(mockQuery);
            when(mockQuery.setParameter(1, 1)).thenReturn(mockQuery);
            when(mockQuery.executeUpdate()).thenReturn(1);

            int result = drinkDAO.softDelete(1);
            assertEquals(1, result);
        }
    }

    @Test
    @Order(6)
    @DisplayName("softDelete() - Id không tồn tại trả về 0")
    void testSoftDelete_NotFound() throws Exception {
        // UPDATE không match id → executeUpdate trả về 0
        Query mockQuery = mock(Query.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString())).thenReturn(mockQuery);
            when(mockQuery.setParameter(1, 999)).thenReturn(mockQuery);
            when(mockQuery.executeUpdate()).thenReturn(0);

            int result = drinkDAO.softDelete(999);
            assertEquals(0, result);
        }
    }

    @Test
    @Order(7)
    @DisplayName("findAll() - Trả về tất cả đồ uống")
    void testFindAll_ReturnsList() throws Exception {
        // SELECT dùng createQuery(jpql, Drink.class) → TypedQuery<Drink>
        @SuppressWarnings("unchecked")
        TypedQuery<Drink> mockQuery = mock(TypedQuery.class);
        List<Drink> expectedList = List.of(
                new Drink(1, "Cafe Den", 25000, "", "", true, 1),
                new Drink(2, "Tra Xanh", 20000, "", "", true, 2));

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString(), eq(Drink.class))).thenReturn(mockQuery);
            when(mockQuery.getResultList()).thenReturn(expectedList);

            List<Drink> list = drinkDAO.findAll();
            assertEquals(2, list.size());
        }
    }

    @Test
    @Order(8)
    @DisplayName("findAllActive() - Chỉ trả về đồ uống đang bán")
    void testFindAllActive_OnlyActive() throws Exception {
        @SuppressWarnings("unchecked")
        TypedQuery<Drink> mockQuery = mock(TypedQuery.class);
        List<Drink> expectedList = List.of(
                new Drink(1, "Cafe Den", 25000, "", "", true, 1));

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString(), eq(Drink.class))).thenReturn(mockQuery);
            when(mockQuery.getResultList()).thenReturn(expectedList);

            List<Drink> list = drinkDAO.findAllActive();
            assertEquals(1, list.size());
            assertTrue(list.get(0).isActive());
        }
    }

    @Test
    @Order(9)
    @DisplayName("findByCategoryId() - Lấy đồ uống theo danh mục")
    void testFindByCategoryId_ReturnsList() throws Exception {
        @SuppressWarnings("unchecked")
        TypedQuery<Drink> mockQuery = mock(TypedQuery.class);
        List<Drink> expectedList = List.of(
                new Drink(1, "Cafe Den", 25000, "", "", true, 1),
                new Drink(3, "Cafe Sua", 30000, "", "", true, 1));

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString(), eq(Drink.class))).thenReturn(mockQuery);
            when(mockQuery.setParameter(1, 1)).thenReturn(mockQuery);
            when(mockQuery.getResultList()).thenReturn(expectedList);

            List<Drink> list = drinkDAO.findByCategoryId(1);
            assertEquals(2, list.size());
            assertEquals(1, list.get(0).getCategoryId());
        }
    }

    @Test
    @Order(10)
    @DisplayName("findByCategoryId() - Danh mục không có đồ uống trả về rỗng")
    void testFindByCategoryId_Empty() throws Exception {
        @SuppressWarnings("unchecked")
        TypedQuery<Drink> mockQuery = mock(TypedQuery.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString(), eq(Drink.class))).thenReturn(mockQuery);
            when(mockQuery.setParameter(1, 99)).thenReturn(mockQuery);
            when(mockQuery.getResultList()).thenReturn(List.of());

            List<Drink> list = drinkDAO.findByCategoryId(99);
            assertTrue(list.isEmpty());
        }
    }

    @Test
    @Order(11)
    @DisplayName("findById() - Tìm thấy đồ uống theo id")
    void testFindById_Found() throws Exception {
        Drink expected = new Drink(1, "Cafe Den", 25000, "", "", true, 1);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.find(Drink.class, 1)).thenReturn(expected);

            Drink drink = drinkDAO.findById(1);
            assertNotNull(drink);
            assertEquals("Cafe Den", drink.getName());
            assertEquals(25000, drink.getPrice());
        }
    }

    @Test
    @Order(12)
    @DisplayName("findById() - Không tìm thấy trả về null")
    void testFindById_NotFound() throws Exception {
        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.find(Drink.class, 999)).thenReturn(null);

            Drink drink = drinkDAO.findById(999);
            assertNull(drink);
        }
    }
}
