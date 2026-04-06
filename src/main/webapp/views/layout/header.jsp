<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="vi" class="light">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>FPolyCoffee - Hệ thống quản lý quán cà phê</title>
            <link
                href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800;900&family=Inter:wght@400;500;600&display=swap"
                rel="stylesheet">
            <link
                href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
                rel="stylesheet">
            <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
            <script>
                tailwind.config = {
                    darkMode: "class",
                    theme: {
                        extend: {
                            colors: {
                                "primary": "#682d00",
                                "primary-container": "#874210",
                                "on-primary": "#ffffff",
                                "primary-fixed": "#ffdbc9",
                                "primary-fixed-dim": "#ffb68c",
                                "secondary": "#944925",
                                "secondary-container": "#fe9e72",
                                "on-secondary": "#ffffff",
                                "secondary-fixed": "#ffdbcd",
                                "surface": "#f7f9ff",
                                "surface-dim": "#d7dadf",
                                "surface-bright": "#f7f9ff",
                                "surface-container-lowest": "#ffffff",
                                "surface-container-low": "#f1f4f9",
                                "surface-container": "#ebeef3",
                                "surface-container-high": "#e5e8ee",
                                "surface-container-highest": "#e0e3e8",
                                "on-surface": "#181c20",
                                "on-surface-variant": "#50453e",
                                "outline": "#82746d",
                                "outline-variant": "#d4c3ba",
                                "tertiary": "#682d00",
                                "tertiary-container": "#8c3f00",
                                "error": "#ba1a1a",
                                "error-container": "#ffdad6",
                                "inverse-surface": "#2d3135",
                                "inverse-on-surface": "#eef1f6",
                            },
                            fontFamily: {
                                "headline": ["Manrope", "sans-serif"],
                                "body": ["Inter", "sans-serif"],
                                "label": ["Inter", "sans-serif"],
                            },
                            borderRadius: {
                                DEFAULT: "0.125rem",
                                "sm": "0.125rem",
                                "md": "0.25rem",
                                "lg": "0.5rem",
                                "xl": "1rem",
                                "2xl": "1.5rem",
                                "full": "9999px",
                            }
                        }
                    }
                }
            </script>
            <style>
                body {
                    font-family: 'Inter', sans-serif;
                    background-color: #f7f9ff;
                    color: #181c20;
                }

                h1,
                h2,
                h3,
                h4,
                h5,
                h6,
                .headline {
                    font-family: 'Manrope', sans-serif;
                }

                .material-symbols-outlined {
                    font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
                    vertical-align: middle;
                }

                .nav-link-active {
                    border-bottom: 2px solid #ffb68c;
                    color: #ffdbc9 !important;
                }

                /* Custom scrollbar */
                ::-webkit-scrollbar {
                    width: 6px;
                }

                ::-webkit-scrollbar-track {
                    background: #f1f4f9;
                }

                ::-webkit-scrollbar-thumb {
                    background: #d4c3ba;
                    border-radius: 9999px;
                }

                /* Table styles */
                .data-table th {
                    background: #f1f4f9;
                    font-family: 'Manrope', sans-serif;
                    font-weight: 700;
                    font-size: 0.75rem;
                    text-transform: uppercase;
                    letter-spacing: 0.05em;
                    color: #50453e;
                    padding: 0.75rem 1rem;
                }

                .data-table td {
                    padding: 0.875rem 1rem;
                    border-bottom: 1px solid #ebeef3;
                    font-size: 0.9rem;
                }

                .data-table tbody tr:hover {
                    background: #fdf6f0;
                }

                /* Form controls */
                .form-control {
                    width: 100%;
                    padding: 0.625rem 0.875rem;
                    border: 1.5px solid #d4c3ba;
                    border-radius: 0.5rem;
                    font-size: 0.9rem;
                    background: white;
                    transition: all 0.2s;
                    outline: none;
                }

                .form-control:focus {
                    border-color: #682d00;
                    box-shadow: 0 0 0 3px rgba(104, 45, 0, 0.1);
                }

                .form-select {
                    width: 100%;
                    padding: 0.625rem 0.875rem;
                    border: 1.5px solid #d4c3ba;
                    border-radius: 0.5rem;
                    font-size: 0.9rem;
                    background: white;
                }

                .form-select:focus {
                    border-color: #682d00;
                    box-shadow: 0 0 0 3px rgba(104, 45, 0, 0.1);
                    outline: none;
                }

                .form-label {
                    font-weight: 600;
                    font-size: 0.875rem;
                    color: #3d1f0d;
                    margin-bottom: 0.375rem;
                    display: block;
                }

                /* Pagination */
                .page-btn {
                    padding: 0.375rem 0.75rem;
                    border: 1.5px solid #d4c3ba;
                    border-radius: 0.5rem;
                    font-size: 0.875rem;
                    cursor: pointer;
                    transition: all 0.2s;
                    color: #50453e;
                    background: white;
                }

                .page-btn:hover {
                    border-color: #682d00;
                    color: #682d00;
                    background: #fdf6f0;
                }

                .page-btn.active {
                    background: #682d00;
                    color: white;
                    border-color: #682d00;
                }

                .page-btn.disabled {
                    opacity: 0.4;
                    pointer-events: none;
                }

                /* Alert */
                .alert {
                    padding: 0.875rem 1rem;
                    border-radius: 0.75rem;
                    font-size: 0.9rem;
                    display: flex;
                    align-items: center;
                    gap: 0.5rem;
                    margin-bottom: 1rem;
                }

                .alert-success {
                    background: #dcfce7;
                    color: #166534;
                    border: 1px solid #bbf7d0;
                }

                .alert-danger {
                    background: #fef2f2;
                    color: #991b1b;
                    border: 1px solid #fecaca;
                }

                /* Badge */
                .badge {
                    display: inline-flex;
                    align-items: center;
                    gap: 0.25rem;
                    padding: 0.25rem 0.625rem;
                    border-radius: 9999px;
                    font-size: 0.75rem;
                    font-weight: 600;
                }

                .badge-success {
                    background: #dcfce7;
                    color: #166534;
                }

                .badge-danger {
                    background: #fef2f2;
                    color: #991b1b;
                }

                .badge-warning {
                    background: #fef9c3;
                    color: #854d0e;
                }

                .badge-secondary {
                    background: #f3f4f6;
                    color: #374151;
                }

                .badge-info {
                    background: #dbeafe;
                    color: #1e40af;
                }

                .badge-gold {
                    background: #ffdbc9;
                    color: #682d00;
                }

                /* Buttons */
                .btn {
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    gap: 0.375rem;
                    padding: 0.5rem 1.25rem;
                    border-radius: 9999px;
                    font-weight: 600;
                    font-size: 0.875rem;
                    cursor: pointer;
                    transition: all 0.2s;
                    border: none;
                    text-decoration: none;
                }

                .btn:hover {
                    opacity: 0.9;
                    transform: translateY(-1px);
                }

                .btn:active {
                    transform: scale(0.97);
                }

                .btn-primary {
                    background: #682d00;
                    color: white;
                }

                .btn-primary:hover {
                    background: #874210;
                    color: white;
                }

                .btn-secondary {
                    background: #ffdbc9;
                    color: #682d00;
                }

                .btn-secondary:hover {
                    background: #ffb68c;
                }

                .btn-outline {
                    background: transparent;
                    color: #682d00;
                    border: 1.5px solid #d4c3ba;
                }

                .btn-outline:hover {
                    background: #fdf6f0;
                    border-color: #682d00;
                    color: #682d00;
                }

                .btn-danger {
                    background: #fef2f2;
                    color: #991b1b;
                    border: 1.5px solid #fecaca;
                }

                .btn-danger:hover {
                    background: #991b1b;
                    color: white;
                }

                .btn-sm {
                    padding: 0.25rem 0.75rem;
                    font-size: 0.8rem;
                }

                /* Card */
                .pc-card {
                    background: white;
                    border-radius: 1.25rem;
                    box-shadow: 0 1px 8px rgba(0, 0, 0, 0.07);
                    border: 1px solid #ebeef3;
                }

                .pc-card-header {
                    padding: 1rem 1.25rem;
                    border-bottom: 1px solid #ebeef3;
                    display: flex;
                    align-items: center;
                    gap: 0.5rem;
                    font-family: 'Manrope', sans-serif;
                    font-weight: 700;
                    font-size: 0.95rem;
                    color: #3d1f0d;
                }

                .section-title {
                    font-family: 'Manrope', sans-serif;
                    font-weight: 800;
                    font-size: 1.35rem;
                    color: #3d1f0d;
                    margin-bottom: 1.25rem;
                    display: flex;
                    align-items: center;
                    gap: 0.5rem;
                }
            </style>
        </head>

        <body>

            <!-- Top Navigation Bar -->
            <nav class="fixed top-0 w-full z-50 bg-primary backdrop-blur-xl shadow-lg">
                <div class="max-w-screen-xl mx-auto px-6 h-16 flex items-center justify-between">
                    <!-- Brand -->
                    <a href="${pageContext.request.contextPath}/trang-chu"
                        class="flex items-center gap-2 text-primary-fixed font-headline font-black text-xl tracking-tight no-underline">
                        <span class="material-symbols-outlined text-primary-fixed-dim">local_cafe</span>
                        FPolyCoffee
                    </a>

                    <!-- Nav links -->
                    <div class="hidden md:flex items-center gap-1">
                        <a href="${pageContext.request.contextPath}/trang-chu"
                            class="flex items-center gap-1 px-4 py-2 rounded-full text-primary-fixed text-sm font-medium hover:bg-white/10 transition-all no-underline">
                            <span class="material-symbols-outlined text-[18px]">home</span> Trang chủ
                        </a>

                        <c:if test="${sessionScope.user != null && sessionScope.user.roleId == 1}">
                            <!-- Quản lý dropdown -->
                            <div class="relative group">
                                <button
                                    class="flex items-center gap-1 px-4 py-2 rounded-full text-primary-fixed text-sm font-medium hover:bg-white/10 transition-all">
                                    <span class="material-symbols-outlined text-[18px]">manage_accounts</span> Quản lý
                                    <span class="material-symbols-outlined text-[16px]">expand_more</span>
                                </button>
                                <div
                                    class="absolute top-full left-0 mt-2 w-56 bg-white rounded-2xl shadow-xl border border-outline-variant/30 py-2 opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-200">
                                    <a href="${pageContext.request.contextPath}/manager/categories"
                                        class="flex items-center gap-3 px-4 py-2.5 text-sm text-on-surface hover:bg-surface-container-low no-underline">
                                        <span class="material-symbols-outlined text-[18px] text-primary">label</span>
                                        Danh mục
                                    </a>
                                    <a href="${pageContext.request.contextPath}/manager/drinks"
                                        class="flex items-center gap-3 px-4 py-2.5 text-sm text-on-surface hover:bg-surface-container-low no-underline">
                                        <span class="material-symbols-outlined text-[18px] text-primary">coffee</span>
                                        Đồ uống
                                    </a>
                                    <a href="${pageContext.request.contextPath}/manager/staff"
                                        class="flex items-center gap-3 px-4 py-2.5 text-sm text-on-surface hover:bg-surface-container-low no-underline">
                                        <span class="material-symbols-outlined text-[18px] text-primary">group</span>
                                        Nhân viên
                                    </a>
                                    <a href="${pageContext.request.contextPath}/manager/bills"
                                        class="flex items-center gap-3 px-4 py-2.5 text-sm text-on-surface hover:bg-surface-container-low no-underline">
                                        <span
                                            class="material-symbols-outlined text-[18px] text-primary">receipt_long</span>
                                        Hóa đơn
                                    </a>
                                    <div class="border-t border-outline-variant/20 my-1"></div>
                                    <a href="${pageContext.request.contextPath}/manager/report"
                                        class="flex items-center gap-3 px-4 py-2.5 text-sm text-on-surface hover:bg-surface-container-low no-underline">
                                        <span
                                            class="material-symbols-outlined text-[18px] text-primary">bar_chart</span>
                                        Thống kê & Báo cáo
                                    </a>
                                </div>
                            </div>
                        </c:if>
                    </div>

                    <!-- User section -->
                    <div class="flex items-center gap-3">
                        <c:if test="${sessionScope.user != null}">
                            <div class="relative group">
                                <button
                                    class="flex items-center gap-2 px-3 py-1.5 rounded-full bg-white/10 hover:bg-white/20 text-primary-fixed text-sm font-medium transition-all">
                                    <span class="material-symbols-outlined text-[20px]">account_circle</span>
                                    <span class="hidden sm:block">${sessionScope.user.fullName}</span>
                                    <c:if test="${sessionScope.user.roleId == 1}">
                                        <span class="badge badge-warning text-[10px] py-0.5 px-2">Admin</span>
                                    </c:if>
                                    <c:if test="${sessionScope.user.roleId == 2}">
                                        <span class="badge badge-gold text-[10px] py-0.5 px-2">Staff</span>
                                    </c:if>
                                    <span class="material-symbols-outlined text-[16px]">expand_more</span>
                                </button>
                                <div
                                    class="absolute top-full right-0 mt-2 w-52 bg-white rounded-2xl shadow-xl border border-outline-variant/30 py-2 opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-200">
                                    <a href="${pageContext.request.contextPath}/thong-tin-ca-nhan"
                                        class="flex items-center gap-3 px-4 py-2.5 text-sm text-on-surface hover:bg-surface-container-low no-underline">
                                        <span class="material-symbols-outlined text-[18px] text-primary">person</span>
                                        Thông tin cá nhân
                                    </a>
                                    <a href="${pageContext.request.contextPath}/doi-mat-khau"
                                        class="flex items-center gap-3 px-4 py-2.5 text-sm text-on-surface hover:bg-surface-container-low no-underline">
                                        <span class="material-symbols-outlined text-[18px] text-primary">lock</span> Đổi
                                        mật khẩu
                                    </a>
                                    <div class="border-t border-outline-variant/20 my-1"></div>
                                    <a href="${pageContext.request.contextPath}/dang-xuat"
                                        class="flex items-center gap-3 px-4 py-2.5 text-sm text-error hover:bg-error-container no-underline">
                                        <span class="material-symbols-outlined text-[18px]">logout</span> Đăng xuất
                                    </a>
                                </div>
                            </div>
                        </c:if>
                        <c:if test="${sessionScope.user == null}">
                            <a href="${pageContext.request.contextPath}/dang-nhap"
                                class="flex items-center gap-2 px-5 py-2 bg-white text-primary rounded-full text-sm font-bold hover:bg-primary-fixed transition-all shadow-sm no-underline">
                                <span class="material-symbols-outlined text-[18px]">login</span> Đăng nhập
                            </a>
                        </c:if>
                    </div>
                </div>
            </nav>

            <!-- Page content wrapper -->
            <div class="pt-16 min-h-screen">
                <div class="max-w-screen-xl mx-auto px-6 py-8">