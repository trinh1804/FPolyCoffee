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

import entity.Drink;
import util.JdbcUtil;

/**
 * Unit test cho DrinkDAO
 */
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class DrinkDAOTest {

    private DrinkDAO drinkDAO;

    @BeforeEach
    void setUp() {
        drinkDAO = new DrinkDAO();
    }

    // Helper: mock 1 row drink
    private ResultSet mockDrinkResultSet(int id, String name, double price,
            boolean status, int categoryId) throws Exception {
        ResultSet rs = mock(ResultSet.class);
        when(rs.next()).thenReturn(true, false);
        when(rs.getInt("id")).thenReturn(id);
        when(rs.getString("name")).thenReturn(name);
        when(rs.getDouble("price")).thenReturn(price);
        when(rs.getString("description")).thenReturn("desc");
        when(rs.getString("image")).thenReturn("");
        when(rs.getBoolean("status")).thenReturn(status);
        when(rs.getInt("category_id")).thenReturn(categoryId);
        return rs;
    }

    // ===================== CREATE =====================

    @Test
    @Order(1)
    @DisplayName("create() - Thêm đồ uống thành công")
    void testCreate_Success() throws Exception {
        Drink drink = new Drink(0, "Cafe Den", 25000, "Cafe den dac", "", true, 1);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(),
                    any(), any(), any(), any(), any(), any()))
                    .thenReturn(1);

            int result = drinkDAO.create(drink);
            assertEquals(1, result);
        }
    }

    @Test
    @Order(2)
    @DisplayName("create() - Lỗi SQL trả về 0")
    void testCreate_Fail() throws Exception {
        Drink drink = new Drink(0, "", 0, "", "", true, 1);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(), any()))
                    .thenThrow(new RuntimeException("SQL error"));

            int result = drinkDAO.create(drink);
            assertEquals(0, result);
        }
    }

    // ===================== UPDATE =====================

    @Test
    @Order(3)
    @DisplayName("update() - Cập nhật đồ uống thành công")
    void testUpdate_Success() throws Exception {
        Drink drink = new Drink(1, "Cafe Sua", 30000, "Cafe sua ngon", "", true, 1);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(),
                    any(), any(), any(), any(), any(), any(), any()))
                    .thenReturn(1);

            int result = drinkDAO.update(drink);
            assertEquals(1, result);
        }
    }

    // ===================== DELETE =====================

    @Test
    @Order(4)
    @DisplayName("delete() - Xóa cứng đồ uống thành công")
    void testDelete_Success() throws Exception {
        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(), eq(1)))
                    .thenReturn(1);

            int result = drinkDAO.delete(1);
            assertEquals(1, result);
        }
    }

    // ===================== SOFT DELETE =====================

    @Test
    @Order(5)
    @DisplayName("softDelete() - Ẩn đồ uống (status=0) thành công")
    void testSoftDelete_Success() throws Exception {
        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(), eq(1)))
                    .thenReturn(1);

            int result = drinkDAO.softDelete(1);
            assertEquals(1, result);
        }
    }

    @Test
    @Order(6)
    @DisplayName("softDelete() - Id không tồn tại trả về 0")
    void testSoftDelete_NotFound() throws Exception {
        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeUpdate(anyString(), eq(999)))
                    .thenReturn(0);

            int result = drinkDAO.softDelete(999);
            assertEquals(0, result);
        }
    }

    // ===================== FIND ALL =====================

    @Test
    @Order(7)
    @DisplayName("findAll() - Trả về tất cả đồ uống")
    void testFindAll_ReturnsList() throws Exception {
        ResultSet mockRs = mock(ResultSet.class);
        when(mockRs.next()).thenReturn(true, true, false);
        when(mockRs.getInt("id")).thenReturn(1, 2);
        when(mockRs.getString("name")).thenReturn("Cafe Den", "Tra Xanh");
        when(mockRs.getDouble("price")).thenReturn(25000.0, 20000.0);
        when(mockRs.getString("description")).thenReturn("", "");
        when(mockRs.getString("image")).thenReturn("", "");
        when(mockRs.getBoolean("status")).thenReturn(true, true);
        when(mockRs.getInt("category_id")).thenReturn(1, 2);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString())).thenReturn(mockRs);

            List<Drink> list = drinkDAO.findAll();
            assertEquals(2, list.size());
        }
    }

    // ===================== FIND ALL ACTIVE =====================

    @Test
    @Order(8)
    @DisplayName("findAllActive() - Chỉ trả về đồ uống đang bán")
    void testFindAllActive_OnlyActive() throws Exception {
        ResultSet mockRs = mock(ResultSet.class);
        when(mockRs.next()).thenReturn(true, false);
        when(mockRs.getInt("id")).thenReturn(1);
        when(mockRs.getString("name")).thenReturn("Cafe Den");
        when(mockRs.getDouble("price")).thenReturn(25000.0);
        when(mockRs.getString("description")).thenReturn("");
        when(mockRs.getString("image")).thenReturn("");
        when(mockRs.getBoolean("status")).thenReturn(true);
        when(mockRs.getInt("category_id")).thenReturn(1);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString())).thenReturn(mockRs);

            List<Drink> list = drinkDAO.findAllActive();
            assertEquals(1, list.size());
            assertTrue(list.get(0).isActive());
        }
    }

    // ===================== FIND BY CATEGORY =====================

    @Test
    @Order(9)
    @DisplayName("findByCategoryId() - Lấy đồ uống theo danh mục")
    void testFindByCategoryId_ReturnsList() throws Exception {
        ResultSet mockRs = mock(ResultSet.class);
        when(mockRs.next()).thenReturn(true, true, false);
        when(mockRs.getInt("id")).thenReturn(1, 3);
        when(mockRs.getString("name")).thenReturn("Cafe Den", "Cafe Sua");
        when(mockRs.getDouble("price")).thenReturn(25000.0, 30000.0);
        when(mockRs.getString("description")).thenReturn("", "");
        when(mockRs.getString("image")).thenReturn("", "");
        when(mockRs.getBoolean("status")).thenReturn(true, true);
        when(mockRs.getInt("category_id")).thenReturn(1, 1);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), eq(1))).thenReturn(mockRs);

            List<Drink> list = drinkDAO.findByCategoryId(1);
            assertEquals(2, list.size());
            assertEquals(1, list.get(0).getCategoryId());
        }
    }

    @Test
    @Order(10)
    @DisplayName("findByCategoryId() - Danh mục không có đồ uống trả về rỗng")
    void testFindByCategoryId_Empty() throws Exception {
        ResultSet mockRs = mock(ResultSet.class);
        when(mockRs.next()).thenReturn(false);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), eq(99))).thenReturn(mockRs);

            List<Drink> list = drinkDAO.findByCategoryId(99);
            assertTrue(list.isEmpty());
        }
    }

    // ===================== FIND BY ID =====================

    @Test
    @Order(11)
    @DisplayName("findById() - Tìm thấy đồ uống theo id")
    void testFindById_Found() throws Exception {
        ResultSet mockRs = mockDrinkResultSet(1, "Cafe Den", 25000, true, 1);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), eq(1))).thenReturn(mockRs);

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
        ResultSet mockRs = mock(ResultSet.class);
        when(mockRs.next()).thenReturn(false);

        try (MockedStatic<JdbcUtil> mock = mockStatic(JdbcUtil.class)) {
            mock.when(() -> JdbcUtil.executeQuery(anyString(), eq(999))).thenReturn(mockRs);

            Drink drink = drinkDAO.findById(999);
            assertNull(drink);
        }
    }
}