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

import entity.Category;
import util.JdbcUtil;

/**
 * Unit test cho CategoryDAO
 */
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class CategoryDAOTest {

    private CategoryDAO categoryDAO;

    @BeforeEach
    void setUp() {
        categoryDAO = new CategoryDAO();
    }

    // Helper: tạo mock ResultSet trả về 1 category
    private ResultSet mockCategoryResultSet(int id, String name, boolean status) throws Exception {
        ResultSet rs = mock(ResultSet.class);
        when(rs.next()).thenReturn(true, false);
        when(rs.getInt("id")).thenReturn(id);
        when(rs.getString("name")).thenReturn(name);
        when(rs.getString("description")).thenReturn("Mo ta " + name);
        when(rs.getString("image")).thenReturn("");
        when(rs.getBoolean("status")).thenReturn(status);
        when(rs.getDate("created_at")).thenReturn(Date.valueOf("2024-01-01"));

        return rs;
    }

    // ===================== CREATE =====================

    @Test
    @Order(1)
    @DisplayName("create() - Thêm danh mục thành công")
    void testCreate_Success() throws Exception {
        Category cat = new Category(0, "Cafe", "Mo ta cafe", "", true, new java.util.Date());

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(),
                    any(), any(), any(), any(), any()))
                    .thenReturn(1);

            int result = categoryDAO.create(cat);
            assertEquals(1, result);
        }
    }

    @Test
    @Order(2)
    @DisplayName("create() - Lỗi SQL trả về 0")
    void testCreate_SqlException() throws Exception {
        Category cat = new Category(0, "Cafe", "", "", true, new java.util.Date());

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(), any()))
                .thenThrow(new RuntimeException("SQL error"));

            int result = categoryDAO.create(cat);
            assertEquals(0, result);
        }            
    }

    // ===================== UPDATE =====================

    @Test
    @Order(3)
    @DisplayName("update() - Cập nhật danh mục thành công")
    void testUpdate_Success() throws Exception {
        Category cat = new Category(1, "Cafe updated", "Mo ta moi", "img.png", true, new java.util.Date());

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(),
                    any(), any(), any(), any(), any()))
                    .thenReturn(1);

            int result = categoryDAO.update(cat);
            assertEquals(1, result);
        }
    }

    // ===================== DELETE =====================

    @Test
    @Order(4)
    @DisplayName("delete() - Xóa danh mục thành công")
    void testDelete_Success() throws Exception {
        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(), eq(1)))
                    .thenReturn(1);

            int result = categoryDAO.delete(1);
            assertEquals(1, result);
        }
    }

    @Test
    @Order(5)
    @DisplayName("delete() - Xóa id không tồn tại trả về 0")
    void testDelete_NotFound() throws Exception {
        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(), eq(999)))
                    .thenReturn(0);

            int result = categoryDAO.delete(999);
            assertEquals(0, result);
        }
    }

    // ===================== FIND ALL =====================

    @Test
    @Order(6)
    @DisplayName("findAll() - Trả về tất cả danh mục")
    void testFindAll_ReturnsList() throws Exception {
        ResultSet mockRs = mock(ResultSet.class);
        when(mockRs.next()).thenReturn(true, true, false);
        when(mockRs.getInt("id")).thenReturn(1, 2);
        when(mockRs.getString("name")).thenReturn("Cafe", "Tra");
        when(mockRs.getString("description")).thenReturn("desc1", "desc2");
        when(mockRs.getString("image")).thenReturn("", "");
        when(mockRs.getBoolean("status")).thenReturn(true, true);
        when(mockRs.getDate("created_at")).thenReturn(Date.valueOf("2024-01-01"));

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString())).thenReturn(mockRs);

            List<Category> list = categoryDAO.findAll();
            assertEquals(2, list.size());
            assertEquals("Cafe", list.get(0).getName());
        }
    }

    // ===================== FIND ALL ACTIVE =====================

    @Test
    @Order(7)
    @DisplayName("findAllActive() - Chỉ trả về danh mục đang hoạt động")
    void testFindAllActive_OnlyActive() throws Exception {
        ResultSet mockRs = mock(ResultSet.class);
        when(mockRs.next()).thenReturn(true, false);
        when(mockRs.getInt("id")).thenReturn(1);
        when(mockRs.getString("name")).thenReturn("Cafe");
        when(mockRs.getString("description")).thenReturn("desc");
        when(mockRs.getString("image")).thenReturn("");
        when(mockRs.getBoolean("status")).thenReturn(true);
        when(mockRs.getDate("created_at")).thenReturn(Date.valueOf("2024-01-01"));

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString())).thenReturn(mockRs);

            List<Category> list = categoryDAO.findAllActive();
            assertEquals(1, list.size());
            assertTrue(list.get(0).isActive());
        }
    }

    // ===================== FIND BY ID =====================

    @Test
    @Order(8)
    @DisplayName("findById() - Tìm thấy danh mục theo id")
    void testFindById_Found() throws Exception {
        ResultSet mockRs = mockCategoryResultSet(1, "Cafe", true);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), eq(1))).thenReturn(mockRs);

            Category cat = categoryDAO.findById(1);
            assertNotNull(cat);
            assertEquals("Cafe", cat.getName());
        }
    }

    @Test
    @Order(9)
    @DisplayName("findById() - Không tìm thấy trả về null")
    void testFindById_NotFound() throws Exception {
        ResultSet mockRs = mock(ResultSet.class);
        when(mockRs.next()).thenReturn(false);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), eq(999))).thenReturn(mockRs);

            Category cat = categoryDAO.findById(999);
            assertNull(cat);
        }
    }

    // ===================== COUNT DRINK IN CATEGORY =====================

    @Test
    @Order(10)
    @DisplayName("countDrinkInCategory() - Đếm đúng số đồ uống trong danh mục")
    void testCountDrink_ReturnsCount() throws Exception {
        ResultSet mockRs = mock(ResultSet.class);
        when(mockRs.next()).thenReturn(true);
        when(mockRs.getInt("cnt")).thenReturn(5);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), eq(1))).thenReturn(mockRs);

            int count = categoryDAO.countDrinkInCategory(1);
            assertEquals(5, count);
        }
    }

    @Test
    @Order(11)
    @DisplayName("countDrinkInCategory() - Danh mục rỗng trả về 0")
    void testCountDrink_Empty() throws Exception {
        ResultSet mockRs = mock(ResultSet.class);
        when(mockRs.next()).thenReturn(true);
        when(mockRs.getInt("cnt")).thenReturn(0);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), eq(2))).thenReturn(mockRs);

            int count = categoryDAO.countDrinkInCategory(2);
            assertEquals(0, count);
        }
    }
}