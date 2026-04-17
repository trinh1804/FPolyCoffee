package com.util;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.Part;

/**
 * Lưu ảnh vào webapp/uploads/ — Tomcat tự serve static, không cần servlet thêm.
 */
public class FileUtil {

    private static final String FOLDER = "/uploads/";

    public static String upload(HttpServletRequest request, String fieldName) throws IOException {
        try {
            Part part = request.getPart(fieldName);
            if (part == null)
                return null;

            String originalName = part.getSubmittedFileName();
            if (originalName == null || originalName.trim().isEmpty())
                return null;

            // Chỉ cho phép ảnh
            String lower = originalName.toLowerCase();
            if (!lower.endsWith(".jpg") && !lower.endsWith(".jpeg")
                    && !lower.endsWith(".png") && !lower.endsWith(".gif")
                    && !lower.endsWith(".webp") && !lower.endsWith(".avif")) {
                return null;
            }

            String ext = originalName.substring(originalName.lastIndexOf('.'));
            String uniqueName = System.currentTimeMillis() + ext;

            String uploadDir = request.getServletContext().getRealPath(FOLDER);
            Path uploadPath = Paths.get(uploadDir);
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }

            part.write(uploadDir + File.separator + uniqueName);
            return uniqueName;

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static boolean delete(HttpServletRequest request, String fileName) {
        if (fileName == null || fileName.trim().isEmpty())
            return false;
        try {
            String uploadDir = request.getServletContext().getRealPath(FOLDER);
            File file = new File(uploadDir, fileName);
            return file.exists() && file.isFile() && file.delete();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}