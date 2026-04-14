<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>500 - Lỗi hệ thống</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>

    <body>
        <div class="container text-center mt-5">
            <h1 class="display-1 text-muted">500</h1>
            <h2>Lỗi hệ thống</h2>
            <p>Đã có lỗi xảy ra. Vui lòng thử lại sau.</p>
            <a href="${pageContext.request.contextPath}/trang-chu" class="btn btn-primary">
                Về trang chủ
            </a>
        </div>
    </body>

    </html>