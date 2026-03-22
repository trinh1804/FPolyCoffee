package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;

public class JdbcUtil {
    static final String DRIVER = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
    static final String DB_URL = "jdbc:sqlserver://localhost:1433;database=FPOLYCOFFEE;encrypt=false";
    static final String USERNAME = "sa";
    static final String PASSWORD = "Trinh123";

    static {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    /** Mở kết nối */
    private static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, USERNAME, PASSWORD);
    }

    /**
     * Tạo PreparedStatement - hỗ trợ cả SQL thường và stored procedure ({CALL ...})
     */
    public static PreparedStatement createPreStmt(String sql, Object... values) throws SQLException {
        Connection conn = getConnection();
        PreparedStatement stmt;
        if (sql.trim().startsWith("{")) {
            stmt = conn.prepareCall(sql);
        } else {
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        }
        for (int i = 0; i < values.length; i++) {
            if (values[i] == null) {
                stmt.setNull(i + 1, Types.NULL);
            } else {
                stmt.setObject(i + 1, values[i]);
            }
        }
        return stmt;
    }

    /** INSERT / UPDATE / DELETE */
    public static int executeUpdate(String sql, Object... values) throws SQLException {
        return createPreStmt(sql, values).executeUpdate();
    }

    /** SELECT */
    public static ResultSet executeQuery(String sql, Object... values) throws SQLException {
        return createPreStmt(sql, values).executeQuery();
    }
}
