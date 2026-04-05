<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>FPolyCoffee - Hệ thống quản lý quán cà phê</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
            <style>
                /* Chỉ giữ lại màu sắc tùy chỉnh */
                :root {
                    --coffee: #3d1f0d;
                    --coffee-mid: #7b4a2d;
                    --gold: #c47c3e;
                    --cream: #fdf6ee;
                    --cream-dark: #f0e4d0;
                }

                body {
                    background-color: var(--cream);
                    min-height: 100vh;
                }

                .navbar {
                    background-color: var(--coffee) !important;
                }

                .navbar-brand,
                .navbar .nav-link {
                    color: #e8d5b7 !important;
                }

                .navbar-brand:hover,
                .navbar .nav-link:hover {
                    color: #f0c070 !important;
                }

                .navbar .dropdown-menu {
                    background-color: var(--coffee-mid);
                    border: none;
                }

                .navbar .dropdown-item {
                    color: #e8d5b7;
                }

                .navbar .dropdown-item:hover {
                    background-color: var(--coffee);
                    color: #f0c070;
                }

                .navbar-toggler {
                    border-color: var(--gold) !important;
                }

                /* Buttons */
                .btn-coffee {
                    background-color: var(--coffee);
                    color: #fdf6ee;
                    border: none;
                }

                .btn-coffee:hover {
                    background-color: var(--coffee-mid);
                    color: #fff;
                }

                .btn-outline-coffee {
                    border: 1.5px solid var(--coffee);
                    color: var(--coffee);
                    background: transparent;
                }

                .btn-outline-coffee:hover {
                    background-color: var(--coffee);
                    color: var(--cream);
                }

                /* Card headers */
                .card-header-coffee {
                    background-color: var(--coffee);
                    color: #fdf6ee;
                }

                .card-header-gold {
                    background-color: var(--gold);
                    color: #1a0a00;
                }

                .card-header-mid {
                    background-color: var(--coffee-mid);
                    color: #fdf6ee;
                }
            </style>
        </head>

        <body>

            <nav class="navbar navbar-expand-lg shadow-sm sticky-top">
                <div class="container">
                    <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/trang-chu">
                        <i class="bi bi-cup-hot-fill me-2"></i>FPolyCoffee
                    </a>
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                        <span class="navbar-toggler-icon"></span>
                    </button>

                    <div class="collapse navbar-collapse" id="navbarNav">
                        <!-- Menu bên trái -->
                        <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/trang-chu">
                                    <i class="bi bi-house-door me-1"></i> Trang chủ
                                </a>
                            </li>

                            <c:if test="${sessionScope.user != null && sessionScope.user.roleId == 1}">
                                <li class="nav-item dropdown">
                                    <a class="nav-link dropdown-toggle" href="#" role="button"
                                        data-bs-toggle="dropdown">
                                        <i class="bi bi-gear me-1"></i> Quản lý
                                    </a>
                                    <ul class="dropdown-menu">
                                        <li>
                                            <a class="dropdown-item"
                                                href="${pageContext.request.contextPath}/manager/categories">
                                                <i class="bi bi-tags me-2"></i> Quản lý danh mục
                                            </a>
                                        </li>
                                        <li>
                                            <hr class="dropdown-divider">
                                        </li>
                                        <li>
                                            <a class="dropdown-item"
                                                href="${pageContext.request.contextPath}/manager/drinks">
                                                <i class="bi bi-cup-straw me-2"></i> Quản lý đồ uống
                                            </a>
                                        </li>
                                        <li>
                                            <hr class="dropdown-divider">
                                        </li>
                                        <li>
                                            <a class="dropdown-item"
                                                href="${pageContext.request.contextPath}/manager/staff">
                                                <i class="bi bi-people me-2"></i> Quản lý nhân viên
                                            </a>
                                        </li>
                                        <li>
                                            <hr class="dropdown-divider">
                                        </li>
                                        <li>
                                            <a class="dropdown-item"
                                                href="${pageContext.request.contextPath}/manager/bills">
                                                <i class="bi bi-receipt me-2"></i> Quản lý hóa đơn
                                            </a>
                                        </li>
                                        <li>
                                            <hr class="dropdown-divider">
                                        </li>
                                        <li>
                                            <a class="dropdown-item"
                                                href="${pageContext.request.contextPath}/manager/report">
                                                <i class="bi bi-graph-up me-2"></i> Thống kê & Báo cáo
                                            </a>
                                        </li>
                                        <li>
                                            <hr class="dropdown-divider">
                                        </li>
                                    </ul>
                                </li>
                            </c:if>
                        </ul>

                        <!-- User dropdown bên phải (chỉ hiện khi đã login) -->
                        <c:if test="${sessionScope.user != null}">
                            <div class="dropdown">
                                <button
                                    class="btn btn-link dropdown-toggle text-decoration-none d-flex align-items-center gap-2"
                                    style="color:#e8d5b7" data-bs-toggle="dropdown">
                                    <i class="bi bi-person-circle fs-5"></i>
                                    <span>${sessionScope.user.fullName}</span>
                                    <c:if test="${sessionScope.user.roleId == 1}">
                                        <span class="badge bg-danger">Admin</span>
                                    </c:if>
                                    <c:if test="${sessionScope.user.roleId == 2}">
                                        <span class="badge"
                                            style="background-color:var(--gold);color:#1a0a00">Staff</span>
                                    </c:if>
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end">
                                    <li>
                                        <a class="dropdown-item"
                                            href="${pageContext.request.contextPath}/thong-tin-ca-nhan">
                                            <i class="bi bi-person me-2"></i> Thông tin cá nhân
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/doi-mat-khau">
                                            <i class="bi bi-key me-2"></i> Đổi mật khẩu
                                        </a>
                                    </li>
                                    <li>
                                        <hr class="dropdown-divider">
                                    </li>
                                    <li>
                                        <a class="dropdown-item text-danger"
                                            href="${pageContext.request.contextPath}/dang-xuat">
                                            <i class="bi bi-box-arrow-right me-2"></i> Đăng xuất
                                        </a>
                                    </li>
                                </ul>
                            </div>
                        </c:if>

                        <!-- Nút đăng nhập bên phải (chỉ hiện khi chưa login) -->
                        <c:if test="${sessionScope.user == null}">
                            <a href="${pageContext.request.contextPath}/dang-nhap" class="btn btn-outline-light">
                                <i class="bi bi-box-arrow-in-right me-1"></i> Đăng nhập
                            </a>
                        </c:if>
                    </div>
                </div>
            </nav>

            <div class="container py-4">