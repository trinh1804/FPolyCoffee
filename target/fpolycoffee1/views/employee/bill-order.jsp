<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ include file="/views/layout/header.jsp" %>

                <c:set var="subtotal" value="${bill.totalPrice + bill.discountAmount}" />

                <!-- ── Breadcrumb + back ── -->
                <div class="flex items-center justify-between mb-4">
                    <h1 class="section-title mb-0" style="font-size:1.25rem">
                        <span class="material-symbols-outlined" style="color:#8B4513">point_of_sale</span>
                        Phiếu: <span style="color:#8B4513;font-family:'Playfair Display',serif">${bill.code}</span>
                    </h1>
                    <a href="${pageContext.request.contextPath}/employee/bills" class="btn btn-outline btn-sm">
                        <span class="material-symbols-outlined text-[16px]">arrow_back</span> Quay lại
                    </a>
                </div>

                <!-- ── Flash messages ── -->
                <c:if test="${not empty orderError}">
                    <div class="alert alert-danger mb-4">
                        <span class="material-symbols-outlined text-[18px]">error</span> ${orderError}
                    </div>
                </c:if>
                <c:if test="${not empty discountMsg}">
                    <div class="alert alert-success mb-4">
                        <span class="material-symbols-outlined text-[18px]">check_circle</span> ${discountMsg}
                    </div>
                </c:if>
                <c:if test="${not empty discountError}">
                    <div class="alert alert-danger mb-4">
                        <span class="material-symbols-outlined text-[18px]">error</span> ${discountError}
                    </div>
                </c:if>
                <c:if test="${not empty customerMsg}">
                    <div class="alert alert-success mb-4">
                        <span class="material-symbols-outlined text-[18px]">check_circle</span> ${customerMsg}
                    </div>
                </c:if>
                <c:if test="${not empty customerError}">
                    <div class="alert alert-danger mb-4">
                        <span class="material-symbols-outlined text-[18px]">error</span> ${customerError}
                    </div>
                </c:if>

                <div class="grid grid-cols-1 lg:grid-cols-5 gap-5">

                    <!-- ══════════════ LEFT – Menu ══════════════ -->
                    <div class="lg:col-span-3">
                        <div class="pc-card">
                            <div class="pc-card-header">
                                <span class="material-symbols-outlined text-[18px]"
                                    style="color:#8B4513">menu_book</span>
                                Thực đơn
                            </div>
                            <div class="p-4">

                                <!-- Category filter -->
                                <div class="flex flex-wrap gap-2 mb-4" id="catFilter">
                                    <button onclick="filterCat('all')" data-cat="all"
                                        class="cat-btn px-4 py-1.5 rounded-full text-sm font-semibold"
                                        style="background:#4A2810;color:#F5E6D3">
                                        Tất cả
                                    </button>
                                    <c:forEach items="${categories}" var="cat">
                                        <button onclick="filterCat('${cat.id}')" data-cat="${cat.id}"
                                            class="cat-btn px-4 py-1.5 rounded-full text-sm font-semibold"
                                            style="background:white;border:1.5px solid #C6956A55;color:#6B3A1F">
                                            ${cat.name}
                                        </button>
                                    </c:forEach>
                                </div>

                                <!-- Search -->
                                <input type="search" id="drinkSearch" placeholder="🔍 Tìm đồ uống..."
                                    oninput="searchDrink(this.value)"
                                    class="w-full mb-4 px-3 py-2 rounded-lg border text-sm"
                                    style="border-color:#E8D5C0;outline:none">

                                <!-- Drink grid -->
                                <div class="grid grid-cols-2 sm:grid-cols-3 gap-2.5" id="drinkGrid">
                                    <c:forEach items="${drinks}" var="drink">
                                        <div class="drink-card" data-cat="${drink.categoryId}"
                                            data-name="${drink.name.toLowerCase()}">
                                            <form action="${pageContext.request.contextPath}/employee/bills/add-drink"
                                                method="post">
                                                <input type="hidden" name="billId" value="${bill.id}">
                                                <input type="hidden" name="drinkId" value="${drink.id}">
                                                <button type="submit"
                                                    class="w-full text-left p-3 rounded-xl transition-all hover:shadow-md"
                                                    style="background:white;border:1.5px solid #EDE0D4;cursor:pointer">
                                                    <div class="font-semibold text-sm mb-1 leading-tight">
                                                        ${drink.name}</div>
                                                    <div class="font-bold text-sm" style="color:#8B4513">
                                                        <fmt:formatNumber value="${drink.price}" pattern="#,##0" /> ₫
                                                    </div>
                                                </button>
                                            </form>
                                        </div>
                                    </c:forEach>
                                </div>

                                <p id="noResult" class="text-center text-sm py-6 hidden" style="color:#9E7B5E">
                                    Không tìm thấy đồ uống phù hợp.
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- ══════════════ RIGHT – Order & Actions ══════════════ -->
                    <div class="lg:col-span-2 flex flex-col gap-4">

                        <!-- ── 1. Danh sách món đã chọn ── -->
                        <div class="pc-card">
                            <div class="pc-card-header justify-between">
                                <span>🛒 Món đã chọn</span>
                                <span class="badge badge-secondary text-xs">${items.size()}
                                    loại</span>
                            </div>

                            <div class="p-3">
                                <c:choose>
                                    <c:when test="${empty items}">
                                        <p class="text-center text-sm py-6" style="color:#9E7B5E">
                                            <span class="material-symbols-outlined block mb-1"
                                                style="font-size:2rem;opacity:.35">shopping_cart</span>
                                            Chưa có món — chọn từ menu bên trái
                                        </p>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach items="${items}" var="item">
                                            <div class="flex items-center gap-2 mb-2 py-1.5 border-b"
                                                style="border-color:#F0E8DF">
                                                <div class="flex-1 min-w-0">
                                                    <div class="text-sm font-semibold truncate">
                                                        ${item.drinkName}</div>
                                                    <div class="text-xs" style="color:#9E7B5E">
                                                        <fmt:formatNumber value="${item.unitPrice}" pattern="#,##0" />
                                                        ₫/ly
                                                    </div>
                                                </div>

                                                <!-- Điều chỉnh số lượng -->
                                                <div class="flex items-center gap-1 flex-shrink-0">
                                                    <form
                                                        action="${pageContext.request.contextPath}/employee/bills/update-qty"
                                                        method="post" class="inline">
                                                        <input type="hidden" name="billId" value="${bill.id}">
                                                        <input type="hidden" name="drinkId" value="${item.drinkId}">
                                                        <input type="hidden" name="qty" value="${item.quantity - 1}">
                                                        <button type="submit"
                                                            class="w-6 h-6 rounded-full text-xs font-bold flex items-center justify-center"
                                                            style="background:#F5E6D3;border:1px solid #C6956A;color:#4A2810"
                                                            title="Giảm">−</button>
                                                    </form>

                                                    <span
                                                        class="w-7 text-center text-sm font-bold">${item.quantity}</span>

                                                    <form
                                                        action="${pageContext.request.contextPath}/employee/bills/update-qty"
                                                        method="post" class="inline">
                                                        <input type="hidden" name="billId" value="${bill.id}">
                                                        <input type="hidden" name="drinkId" value="${item.drinkId}">
                                                        <input type="hidden" name="qty" value="${item.quantity + 1}">
                                                        <button type="submit"
                                                            class="w-6 h-6 rounded-full text-xs font-bold flex items-center justify-center"
                                                            style="background:#4A2810;color:#F5E6D3"
                                                            title="Tăng">+</button>
                                                    </form>

                                                    <form
                                                        action="${pageContext.request.contextPath}/employee/bills/remove-drink"
                                                        method="post" class="inline"
                                                        onsubmit="return confirm('Xóa ${item.drinkName} khỏi phiếu?')">
                                                        <input type="hidden" name="billId" value="${bill.id}">
                                                        <input type="hidden" name="drinkId" value="${item.drinkId}">
                                                        <button type="submit"
                                                            class="w-6 h-6 rounded-full flex items-center justify-center"
                                                            style="background:#FFEBEE;color:#C62828;border:none"
                                                            title="Xóa">
                                                            <span class="material-symbols-outlined"
                                                                style="font-size:13px">close</span>
                                                        </button>
                                                    </form>
                                                </div>

                                                <div class="text-sm font-bold flex-shrink-0"
                                                    style="color:#4A2810;min-width:60px;text-align:right">
                                                    <fmt:formatNumber value="${item.totalPrice}" pattern="#,##0" /> ₫
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Tổng tiền -->
                            <div class="px-3 pb-3 pt-2 border-t" style="border-color:#E8D5C0">
                                <div class="flex justify-between text-sm mb-1">
                                    <span style="color:#6B3A1F">Tạm tính</span>
                                    <span>
                                        <fmt:formatNumber value="${subtotal}" pattern="#,##0" />
                                        ₫
                                    </span>
                                </div>
                                <c:if test="${bill.discountAmount > 0}">
                                    <div class="flex justify-between text-sm mb-1" style="color:#C62828">
                                        <span>
                                            Giảm giá
                                            <c:if test="${discount != null}">
                                                <span class="font-mono text-xs">(${discount.code})</span>
                                            </c:if>
                                        </span>
                                        <span>−
                                            <fmt:formatNumber value="${bill.discountAmount}" pattern="#,##0" /> ₫
                                        </span>
                                    </div>
                                </c:if>
                                <div class="flex justify-between font-bold text-base pt-1 border-t"
                                    style="border-color:#E8D5C0;color:#2C1A0E">
                                    <span>Thành tiền</span>
                                    <span style="color:#8B4513;font-size:1.15rem">
                                        <fmt:formatNumber value="${bill.totalPrice}" pattern="#,##0" /> ₫
                                    </span>
                                </div>
                            </div>
                        </div>

                        <!-- ── 2. Mã giảm giá ── -->
                        <div class="pc-card">
                            <div class="pc-card-header">
                                <span class="material-symbols-outlined text-[16px]"
                                    style="color:#8B4513">local_offer</span>
                                Mã giảm giá
                            </div>
                            <div class="p-3">
                                <c:if test="${discount != null}">
                                    <div class="flex items-center justify-between mb-3 px-3 py-2 rounded-lg"
                                        style="background:#F5E6D3;border:1.5px solid #C6956A">
                                        <div class="flex items-center gap-2">
                                            <span class="material-symbols-outlined text-[16px]"
                                                style="color:#8B4513">check_circle</span>
                                            <div>
                                                <span class="font-mono text-sm font-bold"
                                                    style="color:#4A2810">${discount.code}</span>
                                                <span class="text-xs ml-1" style="color:#6B3A1F">
                                                    (−
                                                    <fmt:formatNumber value="${bill.discountAmount}" pattern="#,##0" />
                                                    ₫)
                                                </span>
                                            </div>
                                        </div>
                                        <form action="${pageContext.request.contextPath}/employee/bills/remove-discount"
                                            method="post"
                                            onsubmit="return confirm('Gỡ mã ${discount.code} khỏi phiếu?')">
                                            <input type="hidden" name="billId" value="${bill.id}">
                                            <button type="submit"
                                                class="flex items-center gap-1 text-xs px-2 py-1 rounded-lg"
                                                style="background:#FFEBEE;color:#C62828;border:1px solid #FFCDD2">
                                                <span class="material-symbols-outlined text-[13px]">close</span>
                                                Gỡ mã
                                            </button>
                                        </form>
                                    </div>
                                </c:if>

                                <!-- Nút chọn nhanh -->
                                <div class="flex flex-wrap gap-1.5 mb-3">
                                    <c:forEach items="${availableDiscounts}" var="dc">
                                        <form action="${pageContext.request.contextPath}/employee/bills/apply-discount"
                                            method="post">
                                            <input type="hidden" name="billId" value="${bill.id}">
                                            <input type="hidden" name="discountCode" value="${dc.code}">
                                            <button type="submit"
                                                class="font-mono text-xs font-bold px-2.5 py-1 rounded-lg border transition-all"
                                                <c:choose>
                                                <c:when test="${discount != null && discount.id == dc.id}">
                                                    style="background:#4A2810;color:#F5E6D3;border-color:#C6956A"
                                                </c:when>
                                                <c:otherwise>
                                                    style="background:#F5E6D3;color:#4A2810;border-color:#C6956A55"
                                                </c:otherwise>
                                                </c:choose>
                                                >
                                                ${dc.code}
                                            </button>
                                            (<c:choose>
                                                <c:when test="${dc.discountType}">
                                                    <fmt:formatNumber value="${dc.discountValue}" pattern="#,##0" />%
                                                </c:when>
                                                <c:otherwise>-
                                                    <fmt:formatNumber value="${dc.discountValue}" pattern="#,##0" />₫
                                                </c:otherwise>
                                            </c:choose>)
                                            </button>
                                        </form>
                                    </c:forEach>
                                    <c:if test="${empty availableDiscounts}">
                                        <p class="text-xs" style="color:#9E7B5E">Không có mã
                                            nào đang hoạt động.</p>
                                    </c:if>
                                </div>

                                <!-- Nhập tay -->
                                <form action="${pageContext.request.contextPath}/employee/bills/apply-discount"
                                    method="post" class="flex gap-2">
                                    <input type="hidden" name="billId" value="${bill.id}">
                                    <input type="text" name="discountCode" placeholder="Nhập mã..."
                                        class="flex-1 px-3 py-1.5 rounded-lg border text-sm font-mono"
                                        style="border-color:#E8D5C0;outline:none;text-transform:uppercase"
                                        oninput="this.value=this.value.toUpperCase()">
                                    <button type="submit" class="btn btn-outline btn-sm">Áp dụng</button>
                                </form>
                            </div>
                        </div>

                        <!-- ── 3. Khách hàng (tích điểm) ── -->
                        <div class="pc-card">
                            <div class="pc-card-header">
                                <span class="material-symbols-outlined text-[16px]"
                                    style="color:#8B4513">person_pin</span>
                                Khách hàng
                            </div>
                            <div class="p-3">
                                <c:if test="${customer != null}">
                                    <div class="flex items-center justify-between mb-3 px-3 py-2 rounded-lg"
                                        style="background:#F5E6D3;border:1.5px solid #C6956A">
                                        <div class="flex items-center gap-2">
                                            <span class="material-symbols-outlined text-[18px]"
                                                style="color:#8B4513">loyalty</span>
                                            <div>
                                                <div class="text-sm font-semibold">
                                                    ${customer.fullName}</div>
                                                <div class="text-xs" style="color:#6B3A1F">
                                                    ${customer.phone} —
                                                    <strong>${customer.point}</strong> điểm
                                                </div>
                                            </div>
                                        </div>
                                        <form action="${pageContext.request.contextPath}/employee/bills/remove-customer"
                                            method="post"
                                            onsubmit="return confirm('Gỡ khách ${customer.fullName} khỏi phiếu?')">
                                            <input type="hidden" name="billId" value="${bill.id}">
                                            <button type="submit"
                                                class="flex items-center gap-1 text-xs px-2 py-1 rounded-lg"
                                                style="background:#FFEBEE;color:#C62828;border:1px solid #FFCDD2">
                                                <span class="material-symbols-outlined text-[13px]">person_remove</span>
                                                Gỡ KH
                                            </button>
                                        </form>
                                    </div>
                                </c:if>

                                <!-- Form gán khách hàng: chỉ nhận số điện thoại -->
                                <form action="${pageContext.request.contextPath}/employee/bills/assign-customer"
                                    method="post" class="flex gap-2" onsubmit="return validateCustomerPhone()">
                                    <input type="hidden" name="billId" value="${bill.id}">
                                    <input type="tel" name="phone" id="customerPhone"
                                        placeholder="SĐT khách (10 chữ số)"
                                        class="flex-1 px-3 py-1.5 rounded-lg border text-sm"
                                        style="border-color:#E8D5C0;outline:none" maxlength="10" pattern="0[0-9]{9}"
                                        title="Số điện thoại phải bắt đầu bằng 0 và có đúng 10 chữ số"
                                        oninput="this.value=this.value.replace(/\D/g,'').slice(0,10)">
                                    <button type="submit" class="btn btn-outline btn-sm whitespace-nowrap">
                                        <span class="material-symbols-outlined text-[14px]">person_search</span>
                                        Gán KH
                                    </button>
                                </form>
                                <p class="text-xs mt-1.5" style="color:#9E7B5E">
                                    Gán khách để tự động tích điểm khi thanh toán.
                                </p>
                            </div>
                        </div>

                        <!-- ── 4. Thanh toán ── -->
                        <div class="pc-card">
                            <div class="pc-card-header">
                                <span class="material-symbols-outlined text-[16px]"
                                    style="color:#8B4513">payments</span>
                                Thanh toán
                            </div>
                            <div class="p-3">
                                <form action="${pageContext.request.contextPath}/employee/bills/complete" method="post"
                                    id="payForm" onsubmit="return confirmPay()">
                                    <input type="hidden" name="billId" value="${bill.id}">

                                    <p class="text-sm font-semibold mb-2" style="color:#4A2810">Phương thức:</p>
                                    <div class="flex gap-3 mb-3">
                                        <label
                                            class="flex items-center gap-2 cursor-pointer px-3 py-2 rounded-lg border flex-1 justify-center transition-all"
                                            style="border-color:#C6956A55" id="lblCash">
                                            <input type="radio" name="paymentMethod" value="cash" checked
                                                onchange="togglePayLabel()" class="accent-amber-800">
                                            <span class="material-symbols-outlined text-[17px]"
                                                style="color:#6B3A1F">payments</span>
                                            <span class="text-sm font-semibold">Tiền
                                                mặt</span>
                                        </label>
                                        <label
                                            class="flex items-center gap-2 cursor-pointer px-3 py-2 rounded-lg border flex-1 justify-center transition-all"
                                            style="border-color:#C6956A55" id="lblOnline">
                                            <input type="radio" name="paymentMethod" value="online"
                                                onchange="togglePayLabel()" class="accent-amber-800">
                                            <span class="material-symbols-outlined text-[17px]"
                                                style="color:#6B3A1F">account_balance</span>
                                            <span class="text-sm font-semibold">Chuyển
                                                khoản</span>
                                        </label>
                                    </div>

                                    <!-- Nút mở trang QR riêng (dễ quét hơn) — chỉ hiện khi chọn chuyển khoản -->
                                    <div id="qrPageBtn" style="display:none;margin-bottom:8px">
                                        <a id="qrPageLink"
                                            href="${pageContext.request.contextPath}/employee/bills/qr?id=${bill.id}"
                                            target="_blank" style="display:flex;align-items:center;justify-content:center;gap:6px;
                                  width:100%;padding:10px;border-radius:10px;
                                  background:#003F8A;color:white;font-weight:700;font-size:13px;
                                  text-decoration:none;transition:opacity .15s" onmouseover="this.style.opacity='.85'"
                                            onmouseout="this.style.opacity='1'">
                                            <span class="material-symbols-outlined"
                                                style="font-size:18px">qr_code_2</span>
                                            Mở trang QR toàn màn hình
                                        </a>
                                    </div>

                                    <!-- QR Panel -->
                                    <div id="qrPanel" style="display:none;margin-bottom:12px;border-radius:12px;
                                             overflow:hidden;border:1.5px solid #C0D8F5">
                                        <div
                                            style="background:#003F8A;padding:10px 14px;display:flex;align-items:center;gap:10px">
                                            <div style="width:36px;height:36px;background:white;border-radius:8px;
                                        display:flex;align-items:center;justify-content:center;flex-shrink:0">
                                                <span
                                                    style="font-size:11px;font-weight:900;color:#003F8A;font-family:Arial,sans-serif;letter-spacing:-0.5px">MB</span>
                                            </div>
                                            <div style="flex:1">
                                                <div style="color:white;font-weight:700;font-size:13px">
                                                    MBBank · 0364298183</div>
                                                <div style="color:rgba(255,255,255,0.75);font-size:11px">
                                                    FPOLY COFFEE</div>
                                            </div>
                                            <div style="background:rgba(255,255,255,0.15);color:white;font-size:10px;font-weight:700;
                                        padding:3px 8px;border-radius:20px;letter-spacing:0.5px">VietQR</div>
                                        </div>
                                        <div style="background:white;padding:16px;text-align:center">
                                            <div id="qrLoading" style="padding:20px 0">
                                                <div style="width:36px;height:36px;border:3px solid #003F8A;border-top-color:transparent;
                                            border-radius:50%;animation:spin .8s linear infinite;margin:0 auto 8px">
                                                </div>
                                                <span style="font-size:12px;color:#666">Đang
                                                    tạo mã QR...</span>
                                            </div>
                                            <img id="qrImg" alt="QR MBBank"
                                                style="display:none;width:210px;height:210px;object-fit:contain;margin:0 auto;border-radius:8px"
                                                onload="qrLoaded()" onerror="qrError()">
                                            <div id="qrError" style="display:none;padding:12px 0">
                                                <span class="material-symbols-outlined"
                                                    style="font-size:40px;color:#ddd">qr_code_scanner</span>
                                                <p style="font-size:12px;color:#999;margin:4px 0">
                                                    Không tải được QR —
                                                    <a id="qrLink" href="#" target="_blank"
                                                        style="color:#003F8A;text-decoration:underline">Mở
                                                        trên VietQR</a>
                                                </p>
                                            </div>
                                            <div id="qrTimer"
                                                style="display:none;margin-top:6px;font-size:11px;color:#888">
                                                QR hết hạn sau <span id="qrCountdown"
                                                    style="color:#C62828;font-weight:700">10:00</span>
                                            </div>
                                        </div>
                                        <div style="background:#F0F6FF;padding:10px 14px;font-size:12px">
                                            <div style="display:flex;justify-content:space-between;margin-bottom:5px">
                                                <span style="color:#666">Số tài
                                                    khoản</span>
                                                <span
                                                    style="font-weight:700;font-family:monospace;font-size:13px;color:#1A1A1A">0364298183</span>
                                            </div>
                                            <div style="display:flex;justify-content:space-between;margin-bottom:5px">
                                                <span style="color:#666">Số
                                                    tiền</span>
                                                <span style="font-weight:700;color:#003F8A;font-size:13px">
                                                    <fmt:formatNumber value="${bill.totalPrice}" pattern="#,##0" />
                                                    &#8363;
                                                </span>
                                            </div>
                                            <div
                                                style="display:flex;justify-content:space-between;padding-top:6px;border-top:1px solid #C0D8F5">
                                                <span style="color:#666">Nội
                                                    dung CK</span>
                                                <span
                                                    style="font-weight:700;font-family:monospace;font-size:12px;color:#2C1A0E">${bill.code}</span>
                                            </div>
                                        </div>
                                        <div style="background:#FFFBEB;border-top:1px solid #FDE68A;padding:8px 12px">
                                            <div style="display:flex;align-items:center;gap:6px;margin-bottom:8px">
                                                <span
                                                    style="width:8px;height:8px;border-radius:50%;background:#F59E0B;flex-shrink:0;animation:pulse 1.5s ease-in-out infinite"></span>
                                                <span style="font-size:11px;color:#92400E">Sau
                                                    khi khách quét QR, nhấn
                                                    "Hoàn thành thanh
                                                    toán"</span>
                                            </div>
                                            <button type="button" id="copyBtn" onclick="copyTransferInfo()" style="width:100%;padding:7px;border-radius:8px;background:#EBF3FF;color:#1565C0;
                                           border:1px solid #B3D3FF;font-size:12px;font-weight:600;cursor:pointer;
                                           display:flex;align-items:center;justify-content:center;gap:4px">
                                                <span class="material-symbols-outlined"
                                                    style="font-size:14px">content_copy</span>
                                                Sao chép thông tin chuyển khoản
                                            </button>
                                        </div>
                                    </div>

                                    <!-- Tổng phải thu -->
                                    <div class="rounded-xl p-3 mb-4 text-center" style="background:#4A2810">
                                        <p class="text-xs mb-1" style="color:#C6956A">Tổng phải
                                            thu</p>
                                        <p class="font-bold text-xl"
                                            style="color:#F5E6D3;font-family:'Playfair Display',serif">
                                            <fmt:formatNumber value="${bill.totalPrice}" pattern="#,##0" /> ₫
                                        </p>
                                    </div>

                                    <button type="submit" class="btn btn-primary w-full py-3 text-base font-bold"
                                        style="font-family:'Playfair Display',serif" <c:if
                                        test="${empty items}">disabled
                                        title="Cần có ít nhất 1 món"</c:if>>
                                        <span class="material-symbols-outlined text-[18px]">check_circle</span>
                                        Hoàn thành thanh toán
                                    </button>
                                </form>

                                <div class="mt-3 border-t pt-3" style="border-color:#E8D5C0">
                                    <form action="${pageContext.request.contextPath}/employee/bills/cancel"
                                        method="post"
                                        onsubmit="return confirm('Hủy phiếu ${bill.code}? Thao tác không thể hoàn tác!')">
                                        <input type="hidden" name="billId" value="${bill.id}">
                                        <button type="submit" class="btn btn-outline btn-sm w-full"
                                            style="color:#C62828;border-color:#C62828">
                                            <span class="material-symbols-outlined text-[15px]">cancel</span>
                                            Hủy phiếu này
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>

                    </div><!-- end RIGHT -->
                </div>

                <div id="bill" data-total="${bill.totalPrice}"></div>
                <script>
                    const QR_BANK = 'MB';
                    const QR_ACCOUNT = '0364298183';
                    const QR_NAME = 'FPOLY COFFEE';
                    const BILL_TOTAL = Math.round(
                        Number(document.getElementById("bill").dataset.total || 0)
                    );
                    const BILL_CODE = '${bill.code}';

                    /* ── Validate phone KH ── */
                    function validateCustomerPhone() {
                        var v = document.getElementById('customerPhone').value;
                        if (!v) { alert('Vui lòng nhập số điện thoại!'); return false; }
                        if (!/^0[0-9]{9}$/.test(v)) {
                            alert('Số điện thoại không hợp lệ!\nPhải bắt đầu bằng 0 và có đúng 10 chữ số.');
                            return false;
                        }
                        return true;
                    }

                    /* ── Countdown 10 phút ── */
                    let countdownTimer = null, countdownSec = 600;
                    function startCountdown() {
                        clearInterval(countdownTimer);
                        countdownSec = 600;
                        var el = document.getElementById('qrCountdown');
                        var td = document.getElementById('qrTimer');
                        if (td) td.style.display = 'block';
                        countdownTimer = setInterval(function () {
                            countdownSec--;
                            if (countdownSec <= 0) {
                                clearInterval(countdownTimer);
                                qrRendered = false;
                                document.getElementById('qrImg').style.display = 'none';
                                document.getElementById('qrLoading').style.display = 'block';
                                document.getElementById('qrLoading').innerHTML =
                                    '<span style="font-size:12px;color:#C62828;display:block;text-align:center">' +
                                    '&#9888; QR hết hạn.<br>' +
                                    '<button onclick="refreshQR()" style="margin-top:6px;padding:4px 12px;background:#003F8A;color:white;border:none;border-radius:6px;cursor:pointer;font-size:12px">Tạo lại QR</button></span>';
                                if (td) td.style.display = 'none';
                                return;
                            }
                            var m = String(Math.floor(countdownSec / 60)).padStart(2, '0');
                            var s = String(countdownSec % 60).padStart(2, '0');
                            if (el) { el.textContent = m + ':' + s; el.style.color = countdownSec < 60 ? '#C62828' : '#888'; }
                        }, 1000);
                    }
                    function refreshQR() {
                        qrRendered = false;
                        document.getElementById('qrLoading').innerHTML =
                            '<div style="width:36px;height:36px;border:3px solid #003F8A;border-top-color:transparent;border-radius:50%;animation:spin .8s linear infinite;margin:0 auto 8px"></div>' +
                            '<span style="font-size:12px;color:#666">Đang tạo mã QR...</span>';
                        document.getElementById('qrLoading').style.display = 'block';
                        renderQR();
                    }

                    /* ── Filter / Search ── */
                    function filterCat(catId) {
                        document.querySelectorAll('.drink-card').forEach(function (el) {
                            el.style.display = (catId === 'all' || el.dataset.cat == catId) ? '' : 'none';
                        });
                        document.querySelectorAll('.cat-btn').forEach(function (btn) {
                            var active = btn.dataset.cat == catId;
                            btn.style.background = active ? '#4A2810' : 'white';
                            btn.style.color = active ? '#F5E6D3' : '#6B3A1F';
                            btn.style.border = active ? 'none' : '1.5px solid rgba(198,149,106,0.33)';
                        });
                        document.getElementById('noResult').classList.add('hidden');
                    }
                    function searchDrink(val) {
                        val = val.toLowerCase().trim();
                        var visible = 0;
                        document.querySelectorAll('.drink-card').forEach(function (el) {
                            var match = el.dataset.name && el.dataset.name.includes(val);
                            el.style.display = match ? '' : 'none';
                            if (match) visible++;
                        });
                        document.getElementById('noResult').classList.toggle('hidden', visible > 0);
                    }

                    /* ── Toggle payment method + QR ── */
                    function togglePayLabel() {
                        var isOnline = document.querySelector('input[name="paymentMethod"]:checked').value === 'online';
                        document.getElementById('lblCash').style.background = !isOnline ? '#F5E6D3' : 'white';
                        document.getElementById('lblOnline').style.background = isOnline ? '#F5E6D3' : 'white';

                        /* Hiện/ẩn nút mở trang QR riêng */
                        document.getElementById('qrPageBtn').style.display = isOnline ? 'block' : 'none';

                        var qrPanel = document.getElementById('qrPanel');
                        if (isOnline) {
                            qrPanel.style.display = 'block';
                            /* Reset lại mỗi lần mở để tải QR mới */
                            qrRendered = false;
                            document.getElementById('qrImg').style.display = 'none';
                            document.getElementById('qrError').style.display = 'none';
                            document.getElementById('qrTimer').style.display = 'none';
                            document.getElementById('qrLoading').style.display = 'block';
                            document.getElementById('qrLoading').innerHTML =
                                '<div style="width:36px;height:36px;border:3px solid #003F8A;border-top-color:transparent;border-radius:50%;animation:spin .8s linear infinite;margin:0 auto 8px"></div>' +
                                '<span style="font-size:12px;color:#666">Đang tạo mã QR...</span>';
                            renderQR();
                        } else {
                            qrPanel.style.display = 'none';
                            clearInterval(countdownTimer);
                        }
                    }

                    /* ── QR ── */
                    function buildQRUrl(amount, info) {
                        // VietQR API: https://img.vietqr.io/image/{bank}-{account}-{template}.png
                        var base = 'https://img.vietqr.io/image';
                        var template = 'compact2';
                        // Dùng encodeURIComponent để tránh lỗi ký tự đặc biệt
                        var query = 'amount=' + encodeURIComponent(amount) +
                            '&addInfo=' + encodeURIComponent(info) +
                            '&accountName=' + encodeURIComponent(QR_NAME);
                        return base + '/' + QR_BANK + '-' + QR_ACCOUNT + '-' + template + '.png?' + query;
                    }
                    var qrRendered = false;
                    function renderQR() {
                        if (qrRendered) return;
                        qrRendered = true;
                        if (BILL_TOTAL <= 0) {
                            document.getElementById('qrLoading').innerHTML =
                                '<span style="font-size:12px;color:#999;display:block;text-align:center">Phiếu chưa có sản phẩm nào.<br>Thêm món trước khi tạo QR.</span>';
                            return;
                        }
                        var url = buildQRUrl(BILL_TOTAL, BILL_CODE);
                        var img = document.getElementById('qrImg');
                        var lnk = document.getElementById('qrLink');
                        if (lnk) lnk.href = url;
                        // Thêm cache-bust để tránh bị cache lỗi
                        img.src = url + '&_t=' + Date.now();
                    }
                    function qrLoaded() {
                        document.getElementById('qrLoading').style.display = 'none';
                        document.getElementById('qrImg').style.display = 'block';
                        startCountdown();
                    }
                    function qrError() {
                        qrRendered = false; // Cho phép retry
                        document.getElementById('qrLoading').style.display = 'none';
                        document.getElementById('qrError').style.display = 'block';
                        var fb = document.getElementById('qrLink');
                        if (fb) fb.href = buildQRUrl(BILL_TOTAL, BILL_CODE);
                    }

                    /* ── Copy ── */
                    function copyTransferInfo() {
                        var btn = document.getElementById('copyBtn');
                        var info = 'Ngân hàng: MBBank\nSố tài khoản: ' + QR_ACCOUNT +
                            '\nTên tài khoản: ' + QR_NAME +
                            '\nSố tiền: ' + BILL_TOTAL.toLocaleString('vi-VN') + ' đ' +
                            '\nNội dung: ' + BILL_CODE;
                        var done = function () {
                            var orig = btn.innerHTML;
                            btn.innerHTML = '<span class="material-symbols-outlined" style="font-size:14px">check_circle</span> Đã sao chép!';
                            btn.style.background = '#D1FAE5'; btn.style.color = '#065F46'; btn.style.borderColor = '#6EE7B7';
                            setTimeout(function () {
                                btn.innerHTML = orig;
                                btn.style.background = '#EBF3FF'; btn.style.color = '#1565C0'; btn.style.borderColor = '#B3D3FF';
                            }, 2200);
                        };
                        if (navigator.clipboard && navigator.clipboard.writeText)
                            navigator.clipboard.writeText(info).then(done).catch(function () { legacyCopy(info, done); });
                        else legacyCopy(info, done);
                    }
                    function legacyCopy(text, cb) {
                        var ta = document.createElement('textarea');
                        ta.value = text; ta.style.cssText = 'position:fixed;opacity:0;top:0;left:0';
                        document.body.appendChild(ta); ta.select(); document.execCommand('copy');
                        document.body.removeChild(ta); cb();
                    }

                    /* ── Confirm pay ── */
                    function confirmPay() {
                        var method = document.querySelector('input[name="paymentMethod"]:checked').value;
                        var fmt = new Intl.NumberFormat('vi-VN').format(BILL_TOTAL);
                        var label = method === 'online' ? 'Chuyển khoản MBBank (0364298183)' : 'Tiền mặt';
                        return confirm('Xác nhận thanh toán phiếu ' + BILL_CODE + '?\nPhương thức: ' + label + '\nTổng tiền: ' + fmt + ' ₫');
                    }

                    (function () {
                        var s = document.createElement('style');
                        s.textContent = '@keyframes spin{to{transform:rotate(360deg)}}@keyframes pulse{0%,100%{opacity:1}50%{opacity:.35}}';
                        document.head.appendChild(s);
                    })();
                </script>

                <%@ include file="/views/layout/footer.jsp" %>