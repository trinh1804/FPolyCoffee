<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>FPolyCoffee — Hệ thống quản lý quán cà phê</title>

            <%-- Google Fonts: Playfair Display (display) + DM Sans (body) --%>
                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link
                    href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700;800;900&family=DM+Sans:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
                <link
                    href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
                    rel="stylesheet">

                <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
                <script>
                    tailwind.config = {
                        darkMode: 'class',
                        theme: {
                            extend: {
                                colors: {
                                    espresso: '#2C1A0E',
                                    roast: '#4A2810',
                                    caramel: '#8B4513',
                                    latte: '#C6956A',
                                    cream: '#F5E6D3',
                                    foam: '#FDF8F3',
                                    steamer: '#E8D5C0',
                                    bark: '#6B3A1F',
                                    gold: '#D4A017',
                                    sage: '#7A9E7E',
                                    error: '#C62828',
                                    'error-bg': '#FFEBEE',
                                },
                                fontFamily: {
                                    display: ['"Playfair Display"', 'Georgia', 'serif'],
                                    body: ['"DM Sans"', 'sans-serif'],
                                },
                                boxShadow: {
                                    'warm-sm': '0 2px 8px rgba(44,26,14,0.12)',
                                    'warm': '0 4px 20px rgba(44,26,14,0.15)',
                                    'warm-lg': '0 8px 40px rgba(44,26,14,0.20)',
                                }
                            }
                        }
                    }
                </script>

                <style>
                    /* ─── Base ─── */
                    *,
                    *::before,
                    *::after {
                        box-sizing: border-box;
                    }

                    body {
                        font-family: 'DM Sans', sans-serif;
                        background-color: #FDF8F3;
                        color: #2C1A0E;
                        -webkit-font-smoothing: antialiased;
                    }

                    h1,
                    h2,
                    h3,
                    h4,
                    h5,
                    .display {
                        font-family: 'Playfair Display', Georgia, serif;
                    }

                    .material-symbols-outlined {
                        font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
                        vertical-align: middle;
                        line-height: 1;
                    }

                    /* ─── Navigation ─── */
                    .nav-glass {
                        background: rgba(44, 26, 14, 0.96);
                        backdrop-filter: blur(16px);
                        border-bottom: 1px solid rgba(197, 149, 106, 0.25);
                    }

                    .nav-link {
                        color: rgba(245, 230, 211, 0.80);
                        font-size: 0.875rem;
                        font-weight: 500;
                        padding: 0.5rem 0.875rem;
                        border-radius: 9999px;
                        transition: all .2s;
                        text-decoration: none;
                        display: inline-flex;
                        align-items: center;
                        gap: 0.375rem;
                    }

                    .nav-link:hover {
                        color: #F5E6D3;
                        background: rgba(255, 255, 255, 0.10);
                    }

                    .nav-link.active {
                        color: #D4A017;
                        background: rgba(212, 160, 23, 0.15);
                    }

                    /* ─── Dropdown ─── */
                    .nav-dropdown {
                        position: relative;
                    }

                    .nav-dropdown-menu {
                        position: absolute;
                        top: calc(100% + 8px);
                        left: 50%;
                        transform: translateX(-50%);
                        min-width: 220px;
                        background: #FDF8F3;
                        border-radius: 1rem;
                        box-shadow: 0 8px 40px rgba(44, 26, 14, .22);
                        border: 1px solid #E8D5C0;
                        padding: 0.5rem;
                        opacity: 0;
                        visibility: hidden;
                        transition: opacity .2s, transform .2s;
                        transform: translateX(-50%) translateY(-6px);
                        z-index: 100;
                    }

                    .nav-dropdown:hover .nav-dropdown-menu,
                    .nav-dropdown:focus-within .nav-dropdown-menu {
                        opacity: 1;
                        visibility: visible;
                        transform: translateX(-50%) translateY(0);
                    }

                    .dropdown-item {
                        display: flex;
                        align-items: center;
                        gap: 0.75rem;
                        padding: 0.625rem 0.875rem;
                        border-radius: 0.625rem;
                        font-size: 0.875rem;
                        font-weight: 500;
                        color: #4A2810;
                        text-decoration: none;
                        transition: background .15s;
                    }

                    .dropdown-item:hover {
                        background: #F5E6D3;
                        color: #2C1A0E;
                    }

                    .dropdown-item .material-symbols-outlined {
                        color: #8B4513;
                        font-size: 18px;
                    }

                    .dropdown-divider {
                        height: 1px;
                        background: #E8D5C0;
                        margin: 0.375rem 0;
                    }

                    /* ─── User pill ─── */
                    .user-pill {
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                        padding: 0.375rem 0.75rem 0.375rem 0.5rem;
                        background: rgba(255, 255, 255, 0.12);
                        border: 1px solid rgba(255, 255, 255, 0.18);
                        border-radius: 9999px;
                        cursor: pointer;
                        transition: background .2s;
                        color: #F5E6D3;
                        font-size: 0.875rem;
                        font-weight: 500;
                    }

                    .user-pill:hover {
                        background: rgba(255, 255, 255, 0.20);
                    }

                    .user-avatar {
                        width: 28px;
                        height: 28px;
                        border-radius: 50%;
                        background: linear-gradient(135deg, #C6956A, #8B4513);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-weight: 700;
                        font-size: 0.75rem;
                        color: white;
                        flex-shrink: 0;
                    }

                    /* ─── Mobile menu ─── */
                    #mobileMenu {
                        display: none;
                        background: #2C1A0E;
                        border-top: 1px solid rgba(197, 149, 106, 0.2);
                    }

                    #mobileMenu.open {
                        display: block;
                    }

                    .mobile-link {
                        display: flex;
                        align-items: center;
                        gap: 0.75rem;
                        padding: 0.875rem 1.25rem;
                        color: #F5E6D3;
                        font-size: 0.9rem;
                        font-weight: 500;
                        text-decoration: none;
                        border-bottom: 1px solid rgba(197, 149, 106, 0.12);
                        transition: background .15s;
                    }

                    .mobile-link:hover {
                        background: rgba(255, 255, 255, 0.07);
                    }

                    .mobile-link .material-symbols-outlined {
                        color: #C6956A;
                        font-size: 20px;
                    }

                    /* ─── Cards ─── */
                    .pc-card {
                        background: #fff;
                        border-radius: 1.25rem;
                        box-shadow: 0 2px 12px rgba(44, 26, 14, 0.08);
                        border: 1px solid #EDE0D4;
                    }

                    .pc-card-header {
                        padding: 1rem 1.25rem;
                        border-bottom: 1px solid #EDE0D4;
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                        font-family: 'Playfair Display', serif;
                        font-weight: 700;
                        font-size: 1rem;
                        color: #2C1A0E;
                    }

                    /* ─── Section title ─── */
                    .section-title {
                        font-family: 'Playfair Display', serif;
                        font-weight: 800;
                        font-size: 1.5rem;
                        color: #2C1A0E;
                        margin-bottom: 1.25rem;
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                    }

                    /* ─── Buttons ─── */
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
                        transition: all .18s;
                        border: none;
                        text-decoration: none;
                        font-family: 'DM Sans', sans-serif;
                    }

                    .btn:hover {
                        transform: translateY(-1px);
                        box-shadow: 0 4px 12px rgba(44, 26, 14, 0.2);
                    }

                    .btn:active {
                        transform: scale(0.97);
                        box-shadow: none;
                    }

                    .btn-primary {
                        background: #4A2810;
                        color: #F5E6D3;
                    }

                    .btn-primary:hover {
                        background: #2C1A0E;
                        color: #F5E6D3;
                    }

                    .btn-secondary {
                        background: #F5E6D3;
                        color: #4A2810;
                    }

                    .btn-secondary:hover {
                        background: #E8D5C0;
                    }

                    .btn-outline {
                        background: transparent;
                        color: #4A2810;
                        border: 1.5px solid #C6956A;
                    }

                    .btn-outline:hover {
                        background: #F5E6D3;
                        border-color: #8B4513;
                    }

                    .btn-danger {
                        background: #FFEBEE;
                        color: #C62828;
                        border: 1.5px solid #FFCDD2;
                    }

                    .btn-danger:hover {
                        background: #C62828;
                        color: white;
                    }

                    .btn-success {
                        background: #E8F5E9;
                        color: #2E7D32;
                        border: 1.5px solid #C8E6C9;
                    }

                    .btn-success:hover {
                        background: #2E7D32;
                        color: white;
                    }

                    .btn-sm {
                        padding: 0.25rem 0.75rem;
                        font-size: 0.8rem;
                    }

                    .btn-lg {
                        padding: 0.75rem 2rem;
                        font-size: 1rem;
                    }

                    .btn-icon {
                        padding: 0.375rem;
                        border-radius: 0.625rem;
                    }

                    /* ─── Form controls ─── */
                    .form-label {
                        font-weight: 600;
                        font-size: 0.875rem;
                        color: #4A2810;
                        margin-bottom: 0.375rem;
                        display: block;
                    }

                    .form-control {
                        width: 100%;
                        padding: 0.625rem 0.875rem;
                        border: 1.5px solid #C6956A33;
                        border-radius: 0.625rem;
                        font-size: 0.9rem;
                        background: white;
                        transition: all .2s;
                        outline: none;
                        font-family: 'DM Sans', sans-serif;
                        color: #2C1A0E;
                    }

                    .form-control:focus {
                        border-color: #8B4513;
                        box-shadow: 0 0 0 3px rgba(139, 69, 19, .12);
                    }

                    .form-select {
                        width: 100%;
                        padding: 0.625rem 0.875rem;
                        border: 1.5px solid #C6956A33;
                        border-radius: 0.625rem;
                        font-size: 0.9rem;
                        background: white;
                        font-family: 'DM Sans', sans-serif;
                        color: #2C1A0E;
                        cursor: pointer;
                    }

                    .form-select:focus {
                        border-color: #8B4513;
                        box-shadow: 0 0 0 3px rgba(139, 69, 19, .12);
                        outline: none;
                    }

                    textarea.form-control {
                        resize: vertical;
                    }

                    /* ─── Badges ─── */
                    .badge {
                        display: inline-flex;
                        align-items: center;
                        gap: 0.25rem;
                        padding: 0.2rem 0.625rem;
                        border-radius: 9999px;
                        font-size: 0.75rem;
                        font-weight: 600;
                    }

                    .badge-success {
                        background: #E8F5E9;
                        color: #2E7D32;
                    }

                    .badge-danger {
                        background: #FFEBEE;
                        color: #C62828;
                    }

                    .badge-warning {
                        background: #FFF8E1;
                        color: #E65100;
                    }

                    .badge-info {
                        background: #E3F2FD;
                        color: #1565C0;
                    }

                    .badge-neutral {
                        background: #F3F0EB;
                        color: #5D4037;
                    }

                    .badge-gold {
                        background: #FFF8E1;
                        color: #8B6914;
                    }

                    .badge-secondary {
                        background: #F5E6D3;
                        color: #6B3A1F;
                    }

                    .badge-primary {
                        background: #4A2810;
                        color: #F5E6D3;
                    }

                    /* ─── Alerts ─── */
                    .alert {
                        padding: 0.875rem 1rem;
                        border-radius: 0.875rem;
                        font-size: 0.9rem;
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                        margin-bottom: 1rem;
                    }

                    .alert-success {
                        background: #E8F5E9;
                        color: #2E7D32;
                        border: 1px solid #C8E6C9;
                    }

                    .alert-danger {
                        background: #FFEBEE;
                        color: #C62828;
                        border: 1px solid #FFCDD2;
                    }

                    .alert-warning {
                        background: #FFF8E1;
                        color: #E65100;
                        border: 1px solid #FFE0B2;
                    }

                    .alert-info {
                        background: #E3F2FD;
                        color: #1565C0;
                        border: 1px solid #BBDEFB;
                    }

                    /* ─── Table ─── */
                    .data-table {
                        border-collapse: collapse;
                        width: 100%;
                    }

                    .data-table th {
                        background: #F5E6D3;
                        font-family: 'DM Sans', sans-serif;
                        font-weight: 700;
                        font-size: 0.72rem;
                        text-transform: uppercase;
                        letter-spacing: 0.06em;
                        color: #6B3A1F;
                        padding: 0.75rem 1rem;
                    }

                    .data-table td {
                        padding: 0.875rem 1rem;
                        border-bottom: 1px solid #F0E6DA;
                        font-size: 0.9rem;
                    }

                    .data-table tbody tr:hover {
                        background: #FDF5EE;
                    }

                    .data-table tbody tr:last-child td {
                        border-bottom: none;
                    }

                    /* ─── Pagination ─── */
                    .page-btn {
                        padding: 0.375rem 0.75rem;
                        border: 1.5px solid #C6956A55;
                        border-radius: 0.5rem;
                        font-size: 0.875rem;
                        cursor: pointer;
                        transition: all .15s;
                        color: #6B3A1F;
                        background: white;
                        text-decoration: none;
                        display: inline-flex;
                        align-items: center;
                    }

                    .page-btn:hover {
                        border-color: #8B4513;
                        color: #4A2810;
                        background: #F5E6D3;
                    }

                    .page-btn.active {
                        background: #4A2810;
                        color: #F5E6D3;
                        border-color: #4A2810;
                    }

                    .page-btn.disabled {
                        opacity: 0.35;
                        pointer-events: none;
                    }

                    /* ─── Modal backdrop ─── */
                    .modal-backdrop {
                        position: fixed;
                        inset: 0;
                        z-index: 60;
                        background: rgba(44, 26, 14, 0.55);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        padding: 1rem;
                    }

                    .modal-box {
                        background: white;
                        border-radius: 1.5rem;
                        width: 100%;
                        max-width: 500px;
                        max-height: 90vh;
                        overflow-y: auto;
                        box-shadow: 0 20px 60px rgba(44, 26, 14, 0.35);
                    }

                    .modal-header {
                        padding: 1.25rem 1.5rem;
                        background: linear-gradient(135deg, #2C1A0E, #4A2810);
                        border-radius: 1.5rem 1.5rem 0 0;
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                    }

                    /* ─── Stat card ─── */
                    .stat-card {
                        background: white;
                        border-radius: 1.25rem;
                        padding: 1.25rem;
                        border: 1px solid #EDE0D4;
                        box-shadow: 0 2px 12px rgba(44, 26, 14, .07);
                        display: flex;
                        align-items: center;
                        gap: 1rem;
                    }

                    .stat-icon {
                        width: 52px;
                        height: 52px;
                        border-radius: 1rem;
                        background: #F5E6D3;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        flex-shrink: 0;
                    }

                    .stat-icon .material-symbols-outlined {
                        color: #8B4513;
                        font-size: 26px;
                    }

                    /* ─── Scrollbar ─── */
                    ::-webkit-scrollbar {
                        width: 6px;
                        height: 6px;
                    }

                    ::-webkit-scrollbar-track {
                        background: #F5E6D3;
                    }

                    ::-webkit-scrollbar-thumb {
                        background: #C6956A;
                        border-radius: 9999px;
                    }

                    /* ─── Coffee bean decorative pattern ─── */
                    .bg-coffee-pattern {
                        background-color: #FDF8F3;
                        background-image: radial-gradient(circle at 1px 1px, rgba(139, 69, 19, 0.06) 1px, transparent 0);
                        background-size: 24px 24px;
                    }
                </style>
        </head>

        <body class="bg-coffee-pattern">

            <%-- ══════════ TOP NAV ══════════ --%>
                <nav class="nav-glass fixed top-0 w-full z-50">
                    <div class="max-w-screen-xl mx-auto px-5 h-[62px] flex items-center justify-between gap-4">

                        <%-- Brand --%>
                            <a href="${pageContext.request.contextPath}/trang-chu"
                                class="flex items-center gap-2.5 no-underline flex-shrink-0">
                                <div class="w-8 h-8 rounded-lg bg-gradient-to-br from-caramel to-latte
                            flex items-center justify-center shadow-warm-sm">
                                    <span class="material-symbols-outlined text-white text-[18px]"
                                        style="font-variation-settings:'FILL' 1">local_cafe</span>
                                </div>
                                <span class="font-display font-bold text-cream text-lg tracking-tight hidden sm:block">
                                    FPoly<span class="text-gold">Coffee</span>
                                </span>
                            </a>

                            <%-- Desktop nav links --%>
                                <div class="hidden md:flex items-center gap-1 flex-1 justify-center">
                                    <a href="${pageContext.request.contextPath}/trang-chu" class="nav-link">
                                        <span class="material-symbols-outlined text-[17px]">home</span> Trang chủ
                                    </a>

                                    <c:if test="${sessionScope.user != null}">
                                        <%-- Nhân viên menu --%>
                                            <div class="nav-dropdown">
                                                <button class="nav-link">
                                                    <span
                                                        class="material-symbols-outlined text-[17px]">point_of_sale</span>
                                                    Bán hàng
                                                    <span class="material-symbols-outlined text-[14px]"
                                                        style="color:rgba(245,230,211,0.5)">expand_more</span>
                                                </button>
                                                <div class="nav-dropdown-menu">
                                                    <a href="${pageContext.request.contextPath}/employee/bills/create"
                                                        class="dropdown-item">
                                                        <span class="material-symbols-outlined">add_circle</span> Tạo
                                                        phiếu mới
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/employee/bills"
                                                        class="dropdown-item">
                                                        <span class="material-symbols-outlined">receipt_long</span>
                                                        Phiếu của tôi
                                                    </a>
                                                </div>
                                            </div>
                                    </c:if>

                                    <c:if test="${sessionScope.user != null && sessionScope.user.roleId == 1}">
                                        <%-- Manager dropdown --%>
                                            <div class="nav-dropdown">
                                                <button class="nav-link">
                                                    <span
                                                        class="material-symbols-outlined text-[17px]">admin_panel_settings</span>
                                                    Quản lý
                                                    <span class="material-symbols-outlined text-[14px]"
                                                        style="color:rgba(245,230,211,0.5)">expand_more</span>
                                                </button>
                                                <div class="nav-dropdown-menu" style="min-width:240px">
                                                    <p style="font-size:0.7rem;font-weight:700;text-transform:uppercase;letter-spacing:0.08em;
                                      color:#9E7B5E;padding:0.5rem 0.875rem 0.25rem">Danh mục & Sản phẩm</p>
                                                    <a href="${pageContext.request.contextPath}/manager/categories"
                                                        class="dropdown-item">
                                                        <span class="material-symbols-outlined">label</span> Danh mục
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/manager/drinks"
                                                        class="dropdown-item">
                                                        <span class="material-symbols-outlined">coffee</span> Đồ uống
                                                    </a>
                                                    <div class="dropdown-divider"></div>
                                                    <p style="font-size:0.7rem;font-weight:700;text-transform:uppercase;letter-spacing:0.08em;
                                      color:#9E7B5E;padding:0.5rem 0.875rem 0.25rem">Vận hành</p>
                                                    <a href="${pageContext.request.contextPath}/manager/bills"
                                                        class="dropdown-item">
                                                        <span class="material-symbols-outlined">receipt_long</span> Hóa
                                                        đơn
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/manager/staff"
                                                        class="dropdown-item">
                                                        <span class="material-symbols-outlined">group</span> Nhân viên
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/manager/discount-codes"
                                                        class="dropdown-item">
                                                        <span class="material-symbols-outlined">local_offer</span> Mã
                                                        giảm giá
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/manager/customer-points"
                                                        class="dropdown-item">
                                                        <span class="material-symbols-outlined">loyalty</span> Điểm
                                                        thưởng
                                                    </a>
                                                    <div class="dropdown-divider"></div>
                                                    <a href="${pageContext.request.contextPath}/manager/report"
                                                        class="dropdown-item">
                                                        <span class="material-symbols-outlined">bar_chart</span> Báo cáo
                                                        & Thống kê
                                                    </a>
                                                </div>
                                            </div>
                                    </c:if>
                                </div>

                                <%-- Right section --%>
                                    <div class="flex items-center gap-2.5 flex-shrink-0">
                                        <c:choose>
                                            <c:when test="${sessionScope.user != null}">
                                                <div class="nav-dropdown">
                                                    <div class="user-pill">
                                                        <div class="user-avatar">
                                                            ${sessionScope.user.fullName.substring(0,1).toUpperCase()}
                                                        </div>
                                                        <span class="hidden sm:block max-w-[120px] truncate">
                                                            ${sessionScope.user.fullName}
                                                        </span>
                                                        <c:if test="${sessionScope.user.roleId == 1}">
                                                            <span
                                                                class="badge badge-gold text-[10px] py-0.5 px-1.5">Admin</span>
                                                        </c:if>
                                                        <span
                                                            class="material-symbols-outlined text-[14px] opacity-60">expand_more</span>
                                                    </div>
                                                    <div class="nav-dropdown-menu"
                                                        style="left:auto;right:0;transform:translateX(0) translateY(-6px)">
                                                        <a href="${pageContext.request.contextPath}/thong-tin-ca-nhan"
                                                            class="dropdown-item">
                                                            <span
                                                                class="material-symbols-outlined">manage_accounts</span>
                                                            Thông tin cá nhân
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/doi-mat-khau"
                                                            class="dropdown-item">
                                                            <span class="material-symbols-outlined">lock_reset</span>
                                                            Đổi mật khẩu
                                                        </a>
                                                        <div class="dropdown-divider"></div>
                                                        <a href="${pageContext.request.contextPath}/dang-xuat"
                                                            class="dropdown-item" style="color:#C62828">
                                                            <span class="material-symbols-outlined"
                                                                style="color:#C62828">logout</span> Đăng xuất
                                                        </a>
                                                    </div>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${pageContext.request.contextPath}/dang-nhap"
                                                    class="btn btn-secondary btn-sm shadow-warm-sm">
                                                    <span class="material-symbols-outlined text-[17px]">login</span>
                                                    Đăng nhập
                                                </a>
                                            </c:otherwise>
                                        </c:choose>

                                        <%-- Mobile hamburger --%>
                                            <button id="mobileToggle" class="md:hidden flex items-center justify-center w-9 h-9 rounded-lg
                               text-cream hover:bg-white/10 transition-colors"
                                                onclick="document.getElementById('mobileMenu').classList.toggle('open')">
                                                <span class="material-symbols-outlined text-[22px]">menu</span>
                                            </button>
                                    </div>
                    </div>

                    <%-- Mobile menu --%>
                        <div id="mobileMenu">
                            <a href="${pageContext.request.contextPath}/trang-chu" class="mobile-link">
                                <span class="material-symbols-outlined">home</span> Trang chủ
                            </a>
                            <c:if test="${sessionScope.user != null}">
                                <a href="${pageContext.request.contextPath}/employee/bills" class="mobile-link">
                                    <span class="material-symbols-outlined">receipt_long</span> Phiếu của tôi
                                </a>
                                <a href="${pageContext.request.contextPath}/employee/bills/create" class="mobile-link">
                                    <span class="material-symbols-outlined">add_circle</span> Tạo phiếu mới
                                </a>
                            </c:if>
                            <c:if test="${sessionScope.user != null && sessionScope.user.roleId == 1}">
                                <a href="${pageContext.request.contextPath}/manager/drinks" class="mobile-link">
                                    <span class="material-symbols-outlined">coffee</span> Đồ uống
                                </a>
                                <a href="${pageContext.request.contextPath}/manager/discount-codes" class="mobile-link">
                                    <span class="material-symbols-outlined">local_offer</span> Mã giảm giá
                                </a>
                                <a href="${pageContext.request.contextPath}/manager/customer-points"
                                    class="mobile-link">
                                    <span class="material-symbols-outlined">loyalty</span> Điểm thưởng
                                </a>
                                <a href="${pageContext.request.contextPath}/manager/report" class="mobile-link">
                                    <span class="material-symbols-outlined">bar_chart</span> Báo cáo
                                </a>
                            </c:if>
                            <c:if test="${sessionScope.user != null}">
                                <a href="${pageContext.request.contextPath}/dang-xuat" class="mobile-link"
                                    style="color:#FFAB91">
                                    <span class="material-symbols-outlined" style="color:#FFAB91">logout</span> Đăng
                                    xuất
                                </a>
                            </c:if>
                        </div>
                </nav>

                <%-- Page wrapper --%>
                    <div style="padding-top:62px; min-height:100vh;">
                        <div class="max-w-screen-xl mx-auto px-5 py-7">