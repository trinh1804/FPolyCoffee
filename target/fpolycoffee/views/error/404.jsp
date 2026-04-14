<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>404 - Không tìm thấy trang</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>

    <body>
        <div class="container text-center mt-5">
            <h1 class="display-1 text-muted">404</h1>
            <h2>Không tìm thấy trang</h2>
            <p>Trang bạn đang tìm kiếm không tồn tại hoặc đã được di chuyển.</p>
            <a href="${pageContext.request.contextPath}/trang-chu" class="btn btn-primary">
                Về trang chủ
            </a>
        </div>
    </body>

    </html>