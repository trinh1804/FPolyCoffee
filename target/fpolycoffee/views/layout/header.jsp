<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PolyCoffee - Hệ thống quản lý quán cà phê</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
            <style>
                .navbar {
                    margin-bottom: 20px;
                }

                .container {
                    min-height: 500px;
                }

                footer {
                    margin-top: 30px;
                    padding: 15px;
                    background: #f8f9fa;
                    text-align: center;
                }

                .error {
                    color: red;
                    font-size: 0.9em;
                }

                .success {
                    color: green;
                    font-size: 0.9em;
                }

                .navbar {
                    height: 50px;
                }

                .navbar .nav-link,
                .navbar-brand {
                    padding-top: 5px;
                    padding-bottom: 5px;
                }
            </style>
        </head>

        <body>
            <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
                <div class="container">
                    <a class="navbar-brand" href="${pageContext.request.contextPath}/trang-chu">
                        <strong>FPolyCoffee</strong>
                    </a>
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navbarNav">
                        <ul class="navbar-nav me-auto">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/trang-chu">
                                    <i class="bi bi-house-door"></i> Trang chủ
                                </a>
                            </li>
                            <c:if test="${sessionScope.user != null}">
                                <c:if test="${sessionScope.user.roleId == 1}">
                                    <li class="nav-item dropdown">
                                        <a class="nav-link dropdown-toggle" href="#" id="managerDropdown" role="button"
                                            data-bs-toggle="dropdown">
                                            <i class="bi bi-gear"></i> Quản lý
                                        </a>
                                        <ul class="dropdown-menu">
                                            <li>
                                                <a class="dropdown-item"
                                                    href="${pageContext.request.contextPath}/manager/categories">
                                                    <i class="bi bi-tags"></i> Quản lý danh mục
                                                </a>
                                            </li>
                                            <li>
                                                <a class="dropdown-item"
                                                    href="${pageContext.request.contextPath}/manager/drinks">
                                                    <i class="bi bi-cup-straw"></i> Quản lý đồ uống
                                                </a>
                                            </li>
                                            <li>
                                                <hr class="dropdown-divider">
                                            </li>
                                            <li>
                                                <a class="dropdown-item"
                                                    href="${pageContext.request.contextPath}/manager/staff">
                                                    <i class="bi bi-people"></i> Quản lý nhân viên
                                                </a>
                                            </li>
                                        </ul>
                                    </li>
                                </c:if>
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/thong-tin-ca-nhan">
                                        <i class="bi bi-person"></i> Thông tin cá nhân
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/doi-mat-khau">
                                        <i class="bi bi-key"></i> Đổi mật khẩu
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/dang-xuat">
                                        <i class="bi bi-box-arrow-right"></i> Đăng xuất
                                    </a>
                                </li>
                            </c:if>
                            <c:if test="${sessionScope.user == null}">
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/dang-nhap">
                                        <i class="bi bi-box-arrow-in-right"></i> Đăng nhập
                                    </a>
                                </li>
                            </c:if>
                        </ul>
                        <c:if test="${sessionScope.user != null}">
                            <span class="navbar-text text-light">
                                <i class="bi bi-person-circle"></i> Xin chào,
                                <strong>${sessionScope.user.fullName}</strong>
                                <c:if test="${sessionScope.user.roleId == 1}">
                                    <span class="badge bg-danger">Quản trị viên</span>
                                </c:if>
                                <c:if test="${sessionScope.user.roleId == 2}">
                                    <span class="badge bg-info">Nhân viên</span>
                                </c:if>
                            </span>
                        </c:if>
                    </div>
                </div>
            </nav>
            <div class="container mt-3">