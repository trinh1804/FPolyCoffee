// package main.java.com.servlet;

// import java.io.File;
// import java.io.FileInputStream;
// import java.io.IOException;
// import java.io.OutputStream;

// import javax.servlet.annotation.WebServlet;
// import javax.servlet.http.HttpServlet;
// import javax.servlet.http.HttpServletRequest;
// import javax.servlet.http.HttpServletResponse;

// import com.util.FileUtil;

// /**
// * Serve ảnh từ thư mục upload cố định bên ngoài webapp.
// * URL: /uploads/ten-file.jpg
// */
// @WebServlet("/uploads/*")
// public class ImageServlet extends HttpServlet {

// @Override
// protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws
// IOException {

// // Lấy tên file từ URL: /uploads/abc.jpg → abc.jpg
// String pathInfo = req.getPathInfo();
// if (pathInfo == null || pathInfo.equals("/")) {
// resp.sendError(HttpServletResponse.SC_NOT_FOUND);
// return;
// }

// // Bỏ dấu "/" đầu
// String fileName = pathInfo.substring(1);

// // Chặn path traversal (../../etc/passwd)
// if (fileName.contains("..") || fileName.contains("/") ||
// fileName.contains("\\")) {
// resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
// return;
// }

// File file = new File(FileUtil.getUploadDir(), fileName);
// if (!file.exists() || !file.isFile()) {
// resp.sendError(HttpServletResponse.SC_NOT_FOUND);
// return;
// }

// // Xác định Content-Type
// String lower = fileName.toLowerCase();
// if (lower.endsWith(".png")) {
// resp.setContentType("image/png");
// } else if (lower.endsWith(".gif")) {
// resp.setContentType("image/gif");
// } else if (lower.endsWith(".webp")) {
// resp.setContentType("image/webp");
// } else {
// resp.setContentType("image/jpeg");
// }

// // Cache 7 ngày
// resp.setHeader("Cache-Control", "public, max-age=604800");
// resp.setContentLengthLong(file.length());

// // Ghi file ra response
// try (FileInputStream in = new FileInputStream(file);
// OutputStream out = resp.getOutputStream()) {
// byte[] buf = new byte[8192];
// int len;
// while ((len = in.read(buf)) != -1) {
// out.write(buf, 0, len);
// }
// }
// }
// }