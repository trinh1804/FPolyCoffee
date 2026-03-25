package util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class FileUtil {
    private static final String FOLDER = "/uploads/";

    public static String upload(HttpServletRequest request, String name) throws IOException {
        try {
            Part part = request.getPart(name);
            if (part == null) return null;
            String fileName = part.getSubmittedFileName();
            if (fileName == null || fileName.isEmpty()) return null;
            
            // Lấy phần mở rộng của file
            String ext = "";
            int lastDot = fileName.lastIndexOf(".");
            if (lastDot > 0) {
                ext = fileName.substring(lastDot);
            }
            
            // Tạo tên file duy nhất
            String uniqueName = System.currentTimeMillis() + ext;
            
            // Lấy đường dẫn thực tế
            String realPath = request.getServletContext().getRealPath(FOLDER);
            if (realPath == null) {
                // Fallback nếu không lấy được realPath
                realPath = request.getServletContext().getInitParameter("uploadPath");
                if (realPath == null) {
                    realPath = System.getProperty("java.io.tmpdir") + "/uploads/";
                }
            }
            
            // Tạo thư mục nếu chưa tồn tại
            Path uploadPath = Paths.get(realPath);
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }
            
            // Lưu file
            String filePath = realPath + File.separator + uniqueName;
            part.write(filePath);
            
            return uniqueName;
        } catch (Exception e) { 
            e.printStackTrace(); 
            return null; 
        }
    }

    public static boolean delete(HttpServletRequest request, String fileName) {
        try {
            if (fileName == null || fileName.isEmpty()) return false;
            String realPath = request.getServletContext().getRealPath(FOLDER);
            if (realPath == null) return false;
            
            File file = new File(realPath, fileName);
            return file.exists() && file.isFile() && file.delete();
        } catch (Exception e) { 
            e.printStackTrace();
            return false; 
        }
    }
}