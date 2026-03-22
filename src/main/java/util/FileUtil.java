package util;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.Part;

public class FileUtil {
    private static final String FOLDER = "/uploads/";

    public static String upload(HttpServletRequest request, String name) throws IOException {
        try {
            Part part = request.getPart(name);
            if (part == null)
                return null;
            String fileName = part.getSubmittedFileName();
            if (fileName == null || fileName.isEmpty())
                return null;
            String ext = fileName.substring(fileName.lastIndexOf("."));
            String uniqueName = System.currentTimeMillis() + ext;
            String realPath = request.getServletContext().getRealPath(FOLDER + uniqueName);
            if (!Files.exists(Path.of(realPath).getParent())) {
                Files.createDirectories(Path.of(realPath).getParent());
            }
            part.write(realPath);
            return uniqueName;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static boolean delete(HttpServletRequest request, String fileName) {
        try {
            if (fileName == null || fileName.isEmpty())
                return false;
            String realPath = request.getServletContext().getRealPath(FOLDER);
            File file = new File(realPath, fileName);
            return file.exists() && file.isFile() && file.delete();
        } catch (Exception e) {
            return false;
        }
    }
}
