<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ include file="/views/layout/header.jsp" %>

                <c:set var="subtotal" value="${bill.totalPrice + bill.discountAmount}" />

                <%-- ── Breadcrumb + back ── --%>
                    <div class="flex items-center justify-between mb-4">
                        <h1 class="section-title mb-0" style="font-size:1.25rem">
                            <span class="material-symbols-outlined" style="color:#8B4513">point_of_sale</span>
                            Phiếu: <span style="color:#8B4513;font-family:'Playfair Display',serif">${bill.code}</span>
                        </h1>
                        <a href="${pageContext.request.contextPath}/employee/bills" class="btn btn-outline btn-sm">
                            <span class="material-symbols-outlined text-[16px]">arrow_back</span> Quay lại
                        </a>
                    </div>

                    <%-- ── Flash messages ── --%>
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

                            <%-- ══════════════ LEFT – Menu ══════════════ --%>
                                <div class="lg:col-span-3">
                                    <div class="pc-card">
                                        <div class="pc-card-header">
                                            <span class="material-symbols-outlined text-[18px]"
                                                style="color:#8B4513">menu_book</span>
                                            Thực đơn
                                        </div>
                                        <div class="p-4">

                                            <%-- Category filter --%>
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

                                                <%-- Search --%>
                                                    <input type="text" id="drinkSearch" placeholder="🔍 Tìm đồ uống..."
                                                        oninput="searchDrink(this.value)"
                                                        class="w-full mb-4 px-3 py-2 rounded-lg border text-sm"
                                                        style="border-color:#E8D5C0;outline:none">

                                                    <%-- Drink grid --%>
                                                        <div class="grid grid-cols-2 sm:grid-cols-3 gap-2.5"
                                                            id="drinkGrid">
                                                            <c:forEach items="${drinks}" var="drink">
                                                                <div class="drink-card" data-cat="${drink.categoryId}"
                                                                    data-name="${drink.name.toLowerCase()}">
                                                                    <form
                                                                        action="${pageContext.request.contextPath}/employee/bills/add-drink"
                                                                        method="post">
                                                                        <input type="hidden" name="billId"
                                                                            value="${bill.id}">
                                                                        <input type="hidden" name="drinkId"
                                                                            value="${drink.id}">
                                                                        <button type="submit"
                                                                            class="w-full text-left p-3 rounded-xl transition-all hover:shadow-md"
                                                                            style="background:white;border:1.5px solid #EDE0D4;cursor:pointer">
                                                                            <div
                                                                                class="font-semibold text-sm mb-1 leading-tight">
                                                                                ${drink.name}</div>
                                                                            <div class="font-bold text-sm"
                                                                                style="color:#8B4513">
                                                                                <fmt:formatNumber value="${drink.price}"
                                                                                    pattern="#,##0" /> ₫
                                                                            </div>
                                                                        </button>
                                                                    </form>
                                                                </div>
                                                            </c:forEach>
                                                        </div>

                                                        <p id="noResult"
                                                            class="text-center text-sm text-gray-400 py-6 hidden">
                                                            Không tìm thấy đồ uống phù hợp.
                                                        </p>
                                        </div>
                                    </div>
                                </div>

                                <%-- ══════════════ RIGHT – Order & Actions ══════════════ --%>
                                    <div class="lg:col-span-2 flex flex-col gap-4">

                                        <%-- ── 1. Danh sách món đã chọn ── --%>
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

                                                                    <%-- Tên + giá đơn --%>
                                                                        <div class="flex-1 min-w-0">
                                                                            <div class="text-sm font-semibold truncate">
                                                                                ${item.drinkName}</div>
                                                                            <div class="text-xs" style="color:#9E7B5E">
                                                                                <fmt:formatNumber
                                                                                    value="${item.unitPrice}"
                                                                                    pattern="#,##0" /> ₫/ly
                                                                            </div>
                                                                        </div>

                                                                        <%-- Điều chỉnh số lượng --%>
                                                                            <div
                                                                                class="flex items-center gap-1 flex-shrink-0">

                                                                                <%-- Nút giảm --%>
                                                                                    <form
                                                                                        action="${pageContext.request.contextPath}/employee/bills/update-qty"
                                                                                        method="post" class="inline">
                                                                                        <input type="hidden"
                                                                                            name="billId"
                                                                                            value="${bill.id}">
                                                                                        <input type="hidden"
                                                                                            name="drinkId"
                                                                                            value="${item.drinkId}">
                                                                                        <input type="hidden" name="qty"
                                                                                            value="${item.quantity - 1}">
                                                                                        <button type="submit"
                                                                                            class="w-6 h-6 rounded-full text-xs font-bold flex items-center justify-center"
                                                                                            style="background:#F5E6D3;border:1px solid #C6956A;color:#4A2810"
                                                                                            title="Giảm">−</button>
                                                                                    </form>

                                                                                    <span
                                                                                        class="w-7 text-center text-sm font-bold">${item.quantity}</span>

                                                                                    <%-- Nút tăng --%>
                                                                                        <form
                                                                                            action="${pageContext.request.contextPath}/employee/bills/update-qty"
                                                                                            method="post"
                                                                                            class="inline">
                                                                                            <input type="hidden"
                                                                                                name="billId"
                                                                                                value="${bill.id}">
                                                                                            <input type="hidden"
                                                                                                name="drinkId"
                                                                                                value="${item.drinkId}">
                                                                                            <input type="hidden"
                                                                                                name="qty"
                                                                                                value="${item.quantity + 1}">
                                                                                            <button type="submit"
                                                                                                class="w-6 h-6 rounded-full text-xs font-bold flex items-center justify-center"
                                                                                                style="background:#4A2810;color:#F5E6D3"
                                                                                                title="Tăng">+</button>
                                                                                        </form>

                                                                                        <%-- Xóa dòng --%>
                                                                                            <form
                                                                                                action="${pageContext.request.contextPath}/employee/bills/remove-drink"
                                                                                                method="post"
                                                                                                class="inline"
                                                                                                onsubmit="return confirm('Xóa ${item.drinkName} khỏi phiếu?')">
                                                                                                <input type="hidden"
                                                                                                    name="billId"
                                                                                                    value="${bill.id}">
                                                                                                <input type="hidden"
                                                                                                    name="drinkId"
                                                                                                    value="${item.drinkId}">
                                                                                                <button type="submit"
                                                                                                    class="w-6 h-6 rounded-full flex items-center justify-center"
                                                                                                    style="background:#FFEBEE;color:#C62828;border:none"
                                                                                                    title="Xóa">
                                                                                                    <span
                                                                                                        class="material-symbols-outlined"
                                                                                                        style="font-size:13px">close</span>
                                                                                                </button>
                                                                                            </form>
                                                                            </div>

                                                                            <%-- Thành tiền --%>
                                                                                <div class="text-sm font-bold flex-shrink-0"
                                                                                    style="color:#4A2810;min-width:60px;text-align:right">
                                                                                    <fmt:formatNumber
                                                                                        value="${item.totalPrice}"
                                                                                        pattern="#,##0" /> ₫
                                                                                </div>
                                                                </div>
                                                            </c:forEach>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <%-- Tổng tiền --%>
                                                    <div class="px-3 pb-3 pt-2 border-t" style="border-color:#E8D5C0">
                                                        <div class="flex justify-between text-sm mb-1">
                                                            <span style="color:#6B3A1F">Tạm tính</span>
                                                            <span>
                                                                <fmt:formatNumber value="${subtotal}" pattern="#,##0" />
                                                                ₫
                                                            </span>
                                                        </div>
                                                        <c:if test="${bill.discountAmount > 0}">
                                                            <div class="flex justify-between text-sm mb-1"
                                                                style="color:#C62828">
                                                                <span>
                                                                    Giảm giá
                                                                    <c:if test="${discount != null}">
                                                                        <span
                                                                            class="font-mono text-xs">(${discount.code})</span>
                                                                    </c:if>
                                                                </span>
                                                                <span>−
                                                                    <fmt:formatNumber value="${bill.discountAmount}"
                                                                        pattern="#,##0" /> ₫
                                                                </span>
                                                            </div>
                                                        </c:if>
                                                        <div class="flex justify-between font-bold text-base pt-1 border-t"
                                                            style="border-color:#E8D5C0;color:#2C1A0E">
                                                            <span>Thành tiền</span>
                                                            <span style="color:#8B4513;font-size:1.15rem">
                                                                <fmt:formatNumber value="${bill.totalPrice}"
                                                                    pattern="#,##0" /> ₫
                                                            </span>
                                                        </div>
                                                    </div>
                                            </div>

                                            <%-- ── 2. Mã giảm giá ── --%>
                                                <div class="pc-card">
                                                    <div class="pc-card-header">
                                                        <span class="material-symbols-outlined text-[16px]"
                                                            style="color:#8B4513">local_offer</span>
                                                        Mã giảm giá
                                                    </div>
                                                    <div class="p-3">

                                                        <%-- Nút chọn nhanh --%>
                                                            <div class="flex flex-wrap gap-1.5 mb-3">
                                                                <c:forEach items="${availableDiscounts}" var="dc">
                                                                    <form
                                                                        action="${pageContext.request.contextPath}/employee/bills/apply-discount"
                                                                        method="post">
                                                                        <input type="hidden" name="billId"
                                                                            value="${bill.id}">
                                                                        <input type="hidden" name="discountCode"
                                                                            value="${dc.code}">
                                                                        <button type="submit"
                                                                            class="font-mono text-xs font-bold px-2.5 py-1 rounded-lg border transition-all"
                                                                            style="${discount != null && discount.id == dc.id
                                            ? 'background:#4A2810;color:#F5E6D3;border-color:#C6956A'
                                            : 'background:#F5E6D3;color:#4A2810;border-color:#C6956A55'}">
                                                                            ${dc.code}
                                                                            (<c:choose>
                                                                                <c:when test="${dc.discountType}">
                                                                                    <fmt:formatNumber
                                                                                        value="${dc.discountValue}"
                                                                                        pattern="#,##0" />%
                                                                                </c:when>
                                                                                <c:otherwise>-
                                                                                    <fmt:formatNumber
                                                                                        value="${dc.discountValue}"
                                                                                        pattern="#,##0" />₫
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

                                                            <%-- Nhập tay --%>
                                                                <form
                                                                    action="${pageContext.request.contextPath}/employee/bills/apply-discount"
                                                                    method="post" class="flex gap-2">
                                                                    <input type="hidden" name="billId"
                                                                        value="${bill.id}">
                                                                    <input type="text" name="discountCode"
                                                                        placeholder="Nhập mã..."
                                                                        class="flex-1 px-3 py-1.5 rounded-lg border text-sm font-mono uppercase"
                                                                        style="border-color:#E8D5C0;outline:none">
                                                                    <button type="submit"
                                                                        class="btn btn-outline btn-sm">Áp dụng</button>
                                                                </form>
                                                    </div>
                                                </div>

                                                <%-- ── 3. Khách hàng (tích điểm) ── --%>
                                                    <div class="pc-card">
                                                        <div class="pc-card-header">
                                                            <span class="material-symbols-outlined text-[16px]"
                                                                style="color:#8B4513">person_pin</span>
                                                            Khách hàng
                                                        </div>
                                                        <div class="p-3">
                                                            <c:if test="${customer != null}">
                                                                <div class="flex items-center gap-2 mb-3 p-2 rounded-lg"
                                                                    style="background:#F5E6D3">
                                                                    <span class="material-symbols-outlined text-[18px]"
                                                                        style="color:#8B4513">loyalty</span>
                                                                    <div>
                                                                        <div class="text-sm font-semibold">
                                                                            ${customer.fullName}</div>
                                                                        <div class="text-xs" style="color:#6B3A1F">
                                                                            ${customer.phone} —
                                                                            <strong>${customer.point}</strong> điểm hiện
                                                                            tại
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </c:if>

                                                            <form
                                                                action="${pageContext.request.contextPath}/employee/bills/assign-customer"
                                                                method="post" class="flex gap-2">
                                                                <input type="hidden" name="billId" value="${bill.id}">
                                                                <input type="text" name="phone"
                                                                    placeholder="SĐT khách (tạo mới nếu chưa có)"
                                                                    value="${customer != null ? customer.phone : ''}"
                                                                    class="flex-1 px-3 py-1.5 rounded-lg border text-sm"
                                                                    style="border-color:#E8D5C0;outline:none">
                                                                <button type="submit"
                                                                    class="btn btn-outline btn-sm whitespace-nowrap">
                                                                    <span
                                                                        class="material-symbols-outlined text-[14px]">person_search</span>
                                                                    Gán KH
                                                                </button>
                                                            </form>
                                                            <p class="text-xs mt-1.5" style="color:#9E7B5E">
                                                                Gán khách để tự động tích điểm khi thanh toán.
                                                            </p>
                                                        </div>
                                                    </div>

                                                    <%-- ── 4. Thanh toán ── --%>
                                                        <div class="pc-card">
                                                            <div class="pc-card-header">
                                                                <span class="material-symbols-outlined text-[16px]"
                                                                    style="color:#8B4513">payments</span>
                                                                Thanh toán
                                                            </div>
                                                            <div class="p-3">

                                                                <form
                                                                    action="${pageContext.request.contextPath}/employee/bills/complete"
                                                                    method="post" id="payForm"
                                                                    onsubmit="return confirmPay()">
                                                                    <input type="hidden" name="billId"
                                                                        value="${bill.id}">

                                                                    <%-- Phương thức --%>
                                                                        <p class="text-sm font-semibold mb-2"
                                                                            style="color:#4A2810">Phương thức:</p>
                                                                        <div class="flex gap-3 mb-4">
                                                                            <label
                                                                                class="flex items-center gap-2 cursor-pointer px-3 py-2 rounded-lg border flex-1 justify-center"
                                                                                style="border-color:#C6956A55"
                                                                                id="lblCash">
                                                                                <input type="radio" name="paymentMethod"
                                                                                    value="cash" checked
                                                                                    onchange="togglePayLabel()"
                                                                                    class="accent-amber-800">
                                                                                <span
                                                                                    class="material-symbols-outlined text-[17px]"
                                                                                    style="color:#6B3A1F">payments</span>
                                                                                <span class="text-sm font-semibold">Tiền
                                                                                    mặt</span>
                                                                            </label>
                                                                            <label
                                                                                class="flex items-center gap-2 cursor-pointer px-3 py-2 rounded-lg border flex-1 justify-center"
                                                                                style="border-color:#C6956A55"
                                                                                id="lblOnline">
                                                                                <input type="radio" name="paymentMethod"
                                                                                    value="online"
                                                                                    onchange="togglePayLabel()"
                                                                                    class="accent-amber-800">
                                                                                <span
                                                                                    class="material-symbols-outlined text-[17px]"
                                                                                    style="color:#6B3A1F">account_balance</span>
                                                                                <span
                                                                                    class="text-sm font-semibold">Chuyển
                                                                                    khoản</span>
                                                                            </label>
                                                                        </div>

                                                                        <%-- Tổng phải thu --%>
                                                                            <div class="rounded-xl p-3 mb-4 text-center"
                                                                                style="background:#4A2810">
                                                                                <p class="text-xs mb-1"
                                                                                    style="color:#C6956A">Tổng phải thu
                                                                                </p>
                                                                                <p class="font-bold text-xl"
                                                                                    style="color:#F5E6D3;font-family:'Playfair Display',serif">
                                                                                    <fmt:formatNumber
                                                                                        value="${bill.totalPrice}"
                                                                                        pattern="#,##0" /> ₫
                                                                                </p>
                                                                            </div>

                                                                            <button type="submit"
                                                                                class="btn btn-primary w-full py-3 text-base font-bold"
                                                                                style="font-family:'Playfair Display',serif"
                                                                                <c:if test="${empty items}">disabled
                                                                                title="Cần có ít nhất 1 món"</c:if>>
                                                                                <span
                                                                                    class="material-symbols-outlined text-[18px]">check_circle</span>
                                                                                Hoàn thành thanh toán
                                                                            </button>
                                                                </form>

                                                                <div class="mt-3 border-t pt-3"
                                                                    style="border-color:#E8D5C0">
                                                                    <form
                                                                        action="${pageContext.request.contextPath}/employee/bills/cancel"
                                                                        method="post"
                                                                        onsubmit="return confirm('Hủy phiếu ${bill.code}? Thao tác không thể hoàn tác!')">
                                                                        <input type="hidden" name="billId"
                                                                            value="${bill.id}">
                                                                        <button type="submit"
                                                                            class="btn btn-outline btn-sm w-full"
                                                                            style="color:#C62828;border-color:#C62828">
                                                                            <span
                                                                                class="material-symbols-outlined text-[15px]">cancel</span>
                                                                            Hủy phiếu này
                                                                        </button>
                                                                    </form>
                                                                </div>
                                                            </div>
                                                        </div>

                                    </div><%-- end RIGHT --%>
                        </div>

                        <script>
                            /* ─── Filter theo danh mục ─── */
                            function filterCat(catId) {
                                document.querySelectorAll('.drink-card').forEach(el => {
                                    el.style.display = (catId === 'all' || el.dataset.cat == catId) ? '' : 'none';
                                });
                                document.querySelectorAll('.cat-btn').forEach(btn => {
                                    const active = btn.dataset.cat == catId;
                                    btn.style.background = active ? '#4A2810' : 'white';
                                    btn.style.color = active ? '#F5E6D3' : '#6B3A1F';
                                    btn.style.border = active ? 'none' : '1.5px solid rgba(198,149,106,0.33)';
                                });
                                document.getElementById('noResult').classList.add('hidden');
                            }

                            /* ─── Tìm kiếm theo tên ─── */
                            function searchDrink(val) {
                                val = val.toLowerCase().trim();
                                let visible = 0;
                                document.querySelectorAll('.drink-card').forEach(el => {
                                    const match = el.dataset.name && el.dataset.name.includes(val);
                                    el.style.display = match ? '' : 'none';
                                    if (match) visible++;
                                });
                                document.getElementById('noResult').classList.toggle('hidden', visible > 0);
                            }

                            /* ─── Highlight phương thức thanh toán ─── */
                            function togglePayLabel() {
                                const cash = document.querySelector('input[value="cash"]').checked;
                                document.getElementById('lblCash').style.background = cash ? '#F5E6D3' : 'white';
                                document.getElementById('lblOnline').style.background = !cash ? '#F5E6D3' : 'white';
                            }

                            /* ─── Confirm hoàn thành ─── */
                            function confirmPay() {
                                const method = document.querySelector('input[name="paymentMethod"]:checked').value;
                                const total = '${bill.totalPrice}';
                                const fmt = new Intl.NumberFormat('vi-VN').format(parseFloat(total));
                                return confirm(
                                    'Xác nhận thanh toán phiếu ${bill.code}?\n' +
                                    'Phương thức: ' + (method === 'online' ? 'Chuyển khoản' : 'Tiền mặt') + '\n' +
                                    'Tổng tiền: ' + fmt + ' ₫'
                                );
                            }
                        </script>

                        <%@ include file="/views/layout/footer.jsp" %>