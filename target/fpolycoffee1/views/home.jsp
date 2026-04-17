<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ include file="/views/layout/header.jsp" %>

                <!-- Hero Section -->
                <div class="-mx-6 -mt-8 relative overflow-hidden"
                    style="background: url('${pageContext.request.contextPath}/uploads/banner_chinh.jpg') center/cover no-repeat; min-height: 440px;">
                    <div class="absolute inset-0"
                        style="background: linear-gradient(135deg, rgba(44,26,14,0.72) 0%, rgba(44,26,14,0.55) 50%, rgba(44,26,14,0.40) 100%);">
                    </div>
                    <div
                        class="relative max-w-screen-xl mx-auto px-6 py-16 grid grid-cols-1 lg:grid-cols-2 gap-10 items-center">
                        <div>
                            <span
                                class="inline-block py-1 px-3 text-xs font-bold rounded-full mb-4 uppercase tracking-widest"
                                style="background:rgba(255,255,255,0.25);color:#FFE0B2;backdrop-filter:blur(4px)">
                                Premium Brewing
                            </span>
                            <h1 class="font-headline text-5xl font-black text-white mb-4 leading-tight"
                                style="text-shadow: 2px 2px 8px rgba(0,0,0,0.5)">
                                Savour the<br>Rich Aroma &<br>Bold Flavor
                            </h1>
                            <p class="text-lg mb-6 leading-relaxed max-w-md"
                                style="color:#F5E6D3;text-shadow:1px 1px 4px rgba(0,0,0,0.4)">
                                Đánh thức giác quan bằng những hạt cà phê rang xay thủ công thượng hạng.
                            </p>
                            <div class="flex flex-wrap gap-4">
                                <c:if test="${sessionScope.user == null}">
                                    <a href="${pageContext.request.contextPath}/dang-nhap"
                                        class="btn btn-secondary text-base px-8 py-3 shadow-xl">
                                        <span class="material-symbols-outlined text-[20px]">coffee</span>
                                        Bắt đầu ngay
                                    </a>
                                </c:if>
                                <c:if test="${sessionScope.user != null}">
                                    <a href="${pageContext.request.contextPath}/employee/bills/create"
                                        class="btn btn-secondary text-base px-8 py-3 shadow-xl">
                                        <span class="material-symbols-outlined text-[20px]">add_circle</span>
                                        Tạo phiếu mới
                                    </a>
                                    <c:if test="${not empty openBills}">
                                        <a href="${pageContext.request.contextPath}/employee/bills"
                                            class="btn btn-outline text-base px-6 py-3 hover:bg-white/20 transition-colors"
                                            style="border-color:rgba(255,255,255,0.5);color:white">
                                            <span class="material-symbols-outlined text-[20px]">pending_actions</span>
                                            ${openBills.size()} phiếu đang mở
                                        </a>
                                    </c:if>
                                </c:if>
                            </div>
                            <div class="flex gap-8 mt-8">
                                <div>
                                    <div class="font-headline font-black text-3xl text-white">${drinks.size()}+
                                    </div>
                                    <div class="text-sm" style="color:#F5E6D3;text-shadow:1px 1px 3px rgba(0,0,0,0.3)">
                                        Loại đồ uống
                                    </div>
                                </div>
                                <div class="border-l border-white/20 pl-8">
                                    <div class="font-headline font-black text-3xl text-white">4.9★</div>
                                    <div class="text-sm" style="color:#F5E6D3;text-shadow:1px 1px 3px rgba(0,0,0,0.3)">
                                        Đánh giá</div>
                                </div>
                                <div class="border-l border-white/20 pl-8">
                                    <div class="font-headline font-black text-3xl text-white">1K+</div>
                                    <div class="text-sm" style="color:#F5E6D3;text-shadow:1px 1px 3px rgba(0,0,0,0.3)">
                                        Khách hàng
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="hidden lg:flex items-center justify-center">
                            <div class="w-80 h-80 rounded-[2rem] overflow-hidden border-2 border-white/20
                        shadow-2xl rotate-3 hover:rotate-0 transition-transform duration-500">
                                <img src="${pageContext.request.contextPath}/uploads/download.jpg"
                                    alt="FPoly Coffee Banner" class="w-full h-full object-cover"
                                    onerror="this.parentElement.innerHTML='<div class=\'w-full h-full bg-white/10 backdrop-blur-sm flex items-center justify-center\'><span class=\'material-symbols-outlined text-white/60\' style=\'font-size:9rem;font-variation-settings:FILL 1,wght 300\'>local_cafe</span></div>'">
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ═══════════════ MENU SECTION ═══════════════ -->
                <div class="mt-14">
                    <div class="text-center mb-8">
                        <span
                            class="inline-block py-1 px-3 bg-primary-fixed text-primary text-xs font-bold rounded-full mb-3 uppercase tracking-widest">
                            Thực đơn
                        </span>
                        <h2 class="font-headline font-extrabold text-3xl text-primary">Đồ Uống Của Chúng Tôi
                        </h2>
                        <div class="w-16 h-1 bg-secondary rounded-full mx-auto mt-3"></div>
                    </div>

                    <!-- Category filter tabs -->
                    <div class="flex flex-wrap justify-center gap-2 mb-8" id="catTabs">
                        <button onclick="filterMenu('all')" data-cat="all" class="menu-cat-btn px-5 py-2 rounded-full text-sm font-semibold transition-all
                       bg-[#5D4037] text-white shadow">
                            Tất cả
                        </button>
                        <c:forEach items="${categories}" var="cat">
                            <button onclick="filterMenu('${cat.id}')" data-cat="${cat.id}" class="menu-cat-btn px-5 py-2 rounded-full text-sm font-semibold transition-all
                           bg-white border border-outline-variant text-on-surface-variant
                           hover:border-primary hover:text-primary">
                                ${cat.name}
                            </button>
                        </c:forEach>
                    </div>

                    <!-- Drinks grid -->
                    <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4" id="menuGrid">
                        <c:forEach items="${drinks}" var="drink">
                            <div class="menu-item" data-cat="${drink.categoryId}">
                                <div
                                    class="pc-card overflow-hidden group hover:-translate-y-1 transition-transform duration-200">
                                    <!-- Image -->
                                    <div class="relative overflow-hidden" style="height:140px;background:#fdf6f0">
                                        <c:choose>
                                            <c:when test="${not empty drink.image}">
                                                <img src="${pageContext.request.contextPath}/uploads/${drink.image}"
                                                    class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                                                    alt="${drink.name}"
                                                    onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
                                                <div class="w-full h-full hidden items-center justify-center">
                                                    <span class="material-symbols-outlined text-primary-fixed-dim"
                                                        style="font-size:4rem;font-variation-settings:'FILL' 1">coffee</span>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="w-full h-full flex items-center justify-center">
                                                    <span class="material-symbols-outlined text-primary-fixed-dim"
                                                        style="font-size:4rem;font-variation-settings:'FILL' 1">coffee</span>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <!-- Info -->
                                    <div class="p-3">
                                        <p class="font-headline font-bold text-sm text-on-surface leading-tight mb-1 overflow-hidden"
                                            style="display:-webkit-box;-webkit-line-clamp:2;line-clamp:2;-webkit-box-orient:vertical;overflow:hidden;">
                                            ${drink.name}
                                        </p>
                                        <p class="text-primary font-black text-base">
                                            <fmt:formatNumber value="${drink.price}" pattern="#,##0" /> ₫
                                        </p>
                                        <c:if test="${sessionScope.user != null}">
                                            <!-- Nhân viên đã đăng nhập: nút thêm nhanh vào phiếu mới -->
                                            <a href="${pageContext.request.contextPath}/employee/bills/create"
                                                class="mt-2 btn btn-primary btn-sm w-full text-xs">
                                                <span class="material-symbols-outlined text-[14px]">add</span>
                                                Đặt ngay
                                            </a>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty drinks}">
                            <div class="col-span-5 text-center py-20 text-on-surface-variant">
                                <span class="material-symbols-outlined block mb-3 opacity-25"
                                    style="font-size:5rem">coffee_off</span>
                                <p class="font-semibold">Hiện chưa có đồ uống nào</p>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Features -->
                <div class="mt-16">
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                        <div class="pc-card p-8 group hover:-translate-y-2 transition-transform duration-300">
                            <div class="w-14 h-14 rounded-2xl bg-primary-fixed flex items-center justify-center mb-6
                        group-hover:bg-primary group-hover:text-white transition-colors">
                                <span
                                    class="material-symbols-outlined text-primary group-hover:text-white text-2xl">coffee</span>
                            </div>
                            <h3 class="font-headline font-bold text-xl text-primary mb-3">Thức uống đa dạng
                            </h3>
                            <p class="text-on-surface-variant text-sm leading-relaxed">
                                Hơn 50 loại từ cà phê, trà, sinh tố đến nước ép tươi ngon.
                            </p>
                        </div>
                        <div class="pc-card p-8 group hover:-translate-y-2 transition-transform duration-300">
                            <div class="w-14 h-14 rounded-2xl bg-primary-fixed flex items-center justify-center mb-6
                        group-hover:bg-primary group-hover:text-white transition-colors">
                                <span
                                    class="material-symbols-outlined text-primary group-hover:text-white text-2xl">verified</span>
                            </div>
                            <h3 class="font-headline font-bold text-xl text-primary mb-3">Chất lượng hàng
                                đầu</h3>
                            <p class="text-on-surface-variant text-sm leading-relaxed">
                                Hạt cà phê chất lượng từ các vùng cao nguyên nổi tiếng, rang xay tại chỗ mỗi
                                ngày.
                            </p>
                        </div>
                        <div class="pc-card p-8 group hover:-translate-y-2 transition-transform duration-300">
                            <div class="w-14 h-14 rounded-2xl bg-primary-fixed flex items-center justify-center mb-6
                        group-hover:bg-primary group-hover:text-white transition-colors">
                                <span
                                    class="material-symbols-outlined text-primary group-hover:text-white text-2xl">weekend</span>
                            </div>
                            <h3 class="font-headline font-bold text-xl text-primary mb-3">Không gian thoải
                                mái</h3>
                            <p class="text-on-surface-variant text-sm leading-relaxed">
                                Rộng rãi, thoáng mát, wifi miễn phí — lý tưởng học tập và gặp gỡ bạn bè.
                            </p>
                        </div>
                    </div>
                </div>

                <script>
                    function filterMenu(catId) {
                        document.querySelectorAll('.menu-cat-btn').forEach(btn => {
                            const active = btn.dataset.cat === catId;
                            btn.className = 'menu-cat-btn px-5 py-2 rounded-full text-sm font-semibold transition-all '
                                + (active
                                    ? 'bg-[#5D4037] text-white shadow'
                                    : 'bg-white border border-outline-variant text-on-surface-variant hover:border-primary hover:text-primary');
                        });
                        document.querySelectorAll('.menu-item').forEach(el => {
                            el.style.display = (catId === 'all' || el.dataset.cat === catId) ? '' : 'none';
                        });
                    }
                </script>

                <%@ include file="/views/layout/footer.jsp" %>