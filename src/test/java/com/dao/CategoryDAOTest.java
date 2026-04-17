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
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.Date;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.persistence.TypedQuery;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;
import org.mockito.MockedStatic;

import com.entity.Category;
import com.util.JpaUtil;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class CategoryDAOTest {

    private CategoryDAO categoryDAO;
    private EntityManager mockEm;
    private EntityTransaction mockTransaction;

    @BeforeEach
    void setUp() {
        categoryDAO = new CategoryDAO();
        mockEm = mock(EntityManager.class);
        mockTransaction = mock(EntityTransaction.class);

        when(mockEm.getTransaction()).thenReturn(mockTransaction);
        when(mockTransaction.isActive()).thenReturn(true);
    }

    @Test
    @Order(1)
    @DisplayName("create() - Thêm danh mục thành công")
    void testCreate_Success() throws Exception {
        Category cat = new Category(null, "Cafe", "Mo ta cafe", "", true, new Date());

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);

            int result = categoryDAO.create(cat);
            assertEquals(1, result);
            verify(mockEm).persist(cat);
            verify(mockTransaction).commit();
        }
    }

    @Test
    @Order(2)
    @DisplayName("create() - Lỗi khi persist trả về 0")
    void testCreate_Exception() throws Exception {
        Category cat = new Category(null, "Cafe", "", "", true, new Date());

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            doThrow(new RuntimeException("DB error")).when(mockEm).persist(any());

            int result = categoryDAO.create(cat);
            assertEquals(0, result);
            verify(mockTransaction).rollback();
        }
    }

    @Test
    @Order(3)
    @DisplayName("update() - Cập nhật danh mục thành công")
    void testUpdate_Success() throws Exception {
        Category cat = new Category(1, "Cafe updated", "Mo ta moi", "img.png", true, new Date());

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.merge(cat)).thenReturn(cat);

            int result = categoryDAO.update(cat);
            assertEquals(1, result);
            verify(mockTransaction).commit();
        }
    }

    @Test
    @Order(4)
    @DisplayName("delete() - Xóa danh mục thành công")
    void testDelete_Success() throws Exception {
        Category cat = new Category(1, "Cafe", "", "", true, new Date());

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.find(Category.class, 1)).thenReturn(cat);

            int result = categoryDAO.delete(1);
            assertEquals(1, result);
            verify(mockEm).remove(cat);
            verify(mockTransaction).commit();
        }
    }

    @Test
    @Order(5)
    @DisplayName("delete() - Xóa id không tồn tại trả về 1 (không có gì để xóa)")
    void testDelete_NotFound() throws Exception {
        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.find(Category.class, 999)).thenReturn(null);

            int result = categoryDAO.delete(999);
            assertEquals(1, result);
            verify(mockEm, never()).remove(any());
        }
    }

    @Test
    @Order(6)
    @DisplayName("findAll() - Trả về tất cả danh mục")
    void testFindAll_ReturnsList() throws Exception {
        @SuppressWarnings("unchecked")
        TypedQuery<Category> mockQuery = mock(TypedQuery.class);
        List<Category> expectedList = List.of(
                new Category(1, "Cafe", "", "", true, new Date()),
                new Category(2, "Tra", "", "", true, new Date()));

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString(), eq(Category.class))).thenReturn(mockQuery);
            when(mockQuery.getResultList()).thenReturn(expectedList);

            List<Category> list = categoryDAO.findAll();
            assertEquals(2, list.size());
            assertEquals("Cafe", list.get(0).getName());
        }
    }

    @Test
    @Order(7)
    @DisplayName("findAllActive() - Chỉ trả về danh mục đang hoạt động")
    void testFindAllActive_OnlyActive() throws Exception {
        @SuppressWarnings("unchecked")
        TypedQuery<Category> mockQuery = mock(TypedQuery.class);
        List<Category> expectedList = List.of(
                new Category(1, "Cafe", "", "", true, new Date()));

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString(), eq(Category.class))).thenReturn(mockQuery);
            when(mockQuery.getResultList()).thenReturn(expectedList);

            List<Category> list = categoryDAO.findAllActive();
            assertEquals(1, list.size());
            assertTrue(list.get(0).isActive());
        }
    }

    @Test
    @Order(8)
    @DisplayName("findById() - Tìm thấy danh mục theo id")
    void testFindById_Found() throws Exception {
        Category expected = new Category(1, "Cafe", "", "", true, new Date());

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.find(Category.class, 1)).thenReturn(expected);

            Category cat = categoryDAO.findById(1);
            assertNotNull(cat);
            assertEquals("Cafe", cat.getName());
        }
    }

    @Test
    @Order(9)
    @DisplayName("findById() - Không tìm thấy trả về null")
    void testFindById_NotFound() throws Exception {
        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.find(Category.class, 999)).thenReturn(null);

            Category cat = categoryDAO.findById(999);
            assertNull(cat);
        }
    }

    @Test
    @Order(10)
    @DisplayName("countDrinkInCategory() - Đếm đúng số đồ uống trong danh mục")
    void testCountDrink_ReturnsCount() throws Exception {
        @SuppressWarnings("unchecked")
        TypedQuery<Long> mockQuery = mock(TypedQuery.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString(), eq(Long.class))).thenReturn(mockQuery);
            when(mockQuery.setParameter(1, 1)).thenReturn(mockQuery);
            when(mockQuery.getSingleResult()).thenReturn(5L);

            int count = categoryDAO.countDrinkInCategory(1);
            assertEquals(5, count);
        }
    }

    @Test
    @Order(11)
    @DisplayName("countDrinkInCategory() - Danh mục rỗng trả về 0")
    void testCountDrink_Empty() throws Exception {
        @SuppressWarnings("unchecked")
        TypedQuery<Long> mockQuery = mock(TypedQuery.class);

        try (MockedStatic<JpaUtil> mock = mockStatic(JpaUtil.class)) {
            mock.when(JpaUtil::getEntityManager).thenReturn(mockEm);
            when(mockEm.createQuery(anyString(), eq(Long.class))).thenReturn(mockQuery);
            when(mockQuery.setParameter(1, 2)).thenReturn(mockQuery);
            when(mockQuery.getSingleResult()).thenReturn(0L);

            int count = categoryDAO.countDrinkInCategory(2);
            assertEquals(0, count);
        }
    }
}