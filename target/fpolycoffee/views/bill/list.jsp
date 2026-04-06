<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ include file="/views/layout/header.jsp" %>

                <!-- Page header -->
                <div class="flex items-center justify-between mb-6">
                    <h1 class="section-title mb-0">
                        <span class="material-symbols-outlined text-primary">receipt_long</span>
                        Quản lý hóa đơn
                    </h1>
                </div>

                <!-- Flash messages -->
                <c:if test="${not empty sessionScope.message}">
                    <div class="alert alert-success">
                        <span class="material-symbols-outlined text-[18px]">check_circle</span>
                        ${sessionScope.message}
                        <c:remove var="message" scope="session" />
                    </div>
                </c:if>
                <c:if test="${not empty sessionScope.error}">
                    <div class="alert alert-danger">
                        <span class="material-symbols-outlined text-[18px]">error</span>
                        ${sessionScope.error}
                        <c:remove var="error" scope="session" />
                    </div>
                </c:if>

                <!-- Status filter tabs -->
                <div class="flex flex-wrap gap-2 mb-6">
                    <a href="${pageContext.request.contextPath}/manager/bills"
                        class="flex items-center gap-2 px-5 py-2.5 rounded-full text-sm font-semibold transition-all no-underline
              ${statusFilter == -1 ? 'bg-primary text-white shadow-md' : 'bg-white text-on-surface-variant border border-outline-variant hover:border-primary hover:text-primary'}">
                        <span class="material-symbols-outlined text-[16px]">list</span>
                        Tất cả
                        <span
                            class="inline-flex items-center justify-center w-5 h-5 rounded-full text-[11px] font-bold
                     ${statusFilter == -1 ? 'bg-white/20 text-white' : 'bg-surface-container text-on-surface-variant'}">
                            ${waitingCount + finishCount + cancelCount}
                        </span>
                    </a>
                    <a href="${pageContext.request.contextPath}/manager/bills?status=0"
                        class="flex items-center gap-2 px-5 py-2.5 rounded-full text-sm font-semibold transition-all no-underline
              ${statusFilter == 0 ? 'bg-amber-600 text-white shadow-md' : 'bg-white text-on-surface-variant border border-outline-variant hover:border-amber-500 hover:text-amber-700'}">
                        <span class="material-symbols-outlined text-[16px]">pending</span>
                        Chờ xử lý
                        <span class="inline-flex items-center justify-center w-5 h-5 rounded-full text-[11px] font-bold
                     ${statusFilter == 0 ? 'bg-white/20 text-white' : 'bg-amber-50 text-amber-700'}">
                            ${waitingCount}
                        </span>
                    </a>
                    <a href="${pageContext.request.contextPath}/manager/bills?status=1"
                        class="flex items-center gap-2 px-5 py-2.5 rounded-full text-sm font-semibold transition-all no-underline
              ${statusFilter == 1 ? 'bg-emerald-600 text-white shadow-md' : 'bg-white text-on-surface-variant border border-outline-variant hover:border-emerald-500 hover:text-emerald-700'}">
                        <span class="material-symbols-outlined text-[16px]">check_circle</span>
                        Hoàn thành
                        <span class="inline-flex items-center justify-center w-5 h-5 rounded-full text-[11px] font-bold
                     ${statusFilter == 1 ? 'bg-white/20 text-white' : 'bg-emerald-50 text-emerald-700'}">
                            ${finishCount}
                        </span>
                    </a>
                    <a href="${pageContext.request.contextPath}/manager/bills?status=2"
                        class="flex items-center gap-2 px-5 py-2.5 rounded-full text-sm font-semibold transition-all no-underline
              ${statusFilter == 2 ? 'bg-red-600 text-white shadow-md' : 'bg-white text-on-surface-variant border border-outline-variant hover:border-red-400 hover:text-red-600'}">
                        <span class="material-symbols-outlined text-[16px]">cancel</span>
                        Đã hủy
                        <span class="inline-flex items-center justify-center w-5 h-5 rounded-full text-[11px] font-bold
                     ${statusFilter == 2 ? 'bg-white/20 text-white' : 'bg-red-50 text-red-600'}">
                            ${cancelCount}
                        </span>
                    </a>
                </div>

                <!-- Bill table card -->
                <div class="pc-card">
                    <div class="pc-card-header justify-between px-5 py-4">
                        <div class="flex items-center gap-2">
                            <span class="material-symbols-outlined text-primary text-[18px]">table_rows</span>
                            <span>Danh sách hóa đơn</span>
                        </div>
                        <span class="badge badge-secondary text-xs">${totalRecords} hóa đơn</span>
                    </div>

                    <div class="overflow-x-auto">
                        <table class="data-table w-full">
                            <thead>
                                <tr>
                                    <th class="text-center w-12">ID</th>
                                    <th>Mã đơn</th>
                                    <th>Ngày tạo</th>
                                    <th class="text-right">Tổng tiền</th>
                                    <th class="text-right">Giảm giá</th>
                                    <th class="text-right">Thành tiền</th>
                                    <th class="text-center">Trạng thái</th>
                                    <th class="text-center">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${bills}" var="bill">
                                    <tr>
                                        <td class="text-center text-on-surface-variant text-xs font-mono">${bill.id}
                                        </td>
                                        <td>
                                            <span
                                                class="font-headline font-bold text-primary text-sm">${bill.code}</span>
                                        </td>
                                        <td>
                                            <div class="flex items-center gap-1.5 text-sm text-on-surface-variant">
                                                <span
                                                    class="material-symbols-outlined text-[15px]">calendar_today</span>
                                                <fmt:formatDate value="${bill.createdAt}" pattern="dd/MM/yyyy" />
                                            </div>
                                        </td>
                                        <td class="text-right text-sm text-on-surface-variant">
                                            <fmt:formatNumber value="${bill.totalPrice + bill.discountAmount}"
                                                pattern="#,##0" /> ₫
                                        </td>
                                        <td class="text-right">
                                            <c:choose>
                                                <c:when test="${bill.discountAmount > 0}">
                                                    <span class="text-error text-sm font-semibold">
                                                        -
                                                        <fmt:formatNumber value="${bill.discountAmount}"
                                                            pattern="#,##0" /> ₫
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-on-surface-variant text-sm">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-right">
                                            <span class="font-headline font-bold text-primary text-base">
                                                <fmt:formatNumber value="${bill.totalPrice}" pattern="#,##0" /> ₫
                                            </span>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${bill.status == 0}">
                                                    <span class="badge badge-warning">
                                                        <span
                                                            class="material-symbols-outlined text-[13px]">pending</span>
                                                        Chờ xử lý
                                                    </span>
                                                </c:when>
                                                <c:when test="${bill.status == 1}">
                                                    <span class="badge badge-success">
                                                        <span
                                                            class="material-symbols-outlined text-[13px]">check_circle</span>
                                                        Hoàn thành
                                                    </span>
                                                </c:when>
                                                <c:when test="${bill.status == 2}">
                                                    <span class="badge badge-danger">
                                                        <span
                                                            class="material-symbols-outlined text-[13px]">cancel</span>
                                                        Đã hủy
                                                    </span>
                                                </c:when>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <div class="flex items-center justify-center gap-1.5">
                                                <a href="${pageContext.request.contextPath}/manager/bills/detail?id=${bill.id}"
                                                    class="btn btn-secondary btn-sm" title="Xem chi tiết">
                                                    <span
                                                        class="material-symbols-outlined text-[15px]">visibility</span>
                                                </a>
                                                <c:if test="${bill.status == 0}">
                                                    <form
                                                        action="${pageContext.request.contextPath}/manager/bills/complete"
                                                        method="post" class="inline"
                                                        onsubmit="return confirm('Xác nhận hoàn thành đơn ${bill.code}?')">
                                                        <input type="hidden" name="id" value="${bill.id}">
                                                        <button type="submit" class="btn btn-sm" title="Hoàn thành"
                                                            style="background:#dcfce7;color:#166534;border:1.5px solid #bbf7d0">
                                                            <span
                                                                class="material-symbols-outlined text-[15px]">check</span>
                                                        </button>
                                                    </form>
                                                    <form
                                                        action="${pageContext.request.contextPath}/manager/bills/cancel"
                                                        method="post" class="inline"
                                                        onsubmit="return confirm('Hủy đơn hàng ${bill.code}?')">
                                                        <input type="hidden" name="id" value="${bill.id}">
                                                        <button type="submit" class="btn btn-danger btn-sm"
                                                            title="Hủy đơn">
                                                            <span
                                                                class="material-symbols-outlined text-[15px]">close</span>
                                                        </button>
                                                    </form>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty bills}">
                                    <tr>
                                        <td colspan="8" class="text-center py-16 text-on-surface-variant">
                                            <span class="material-symbols-outlined block mb-3 opacity-25"
                                                style="font-size:4rem">receipt_long</span>
                                            <p class="font-semibold mb-1">Không có hóa đơn nào</p>
                                            <p class="text-sm opacity-60">Thử thay đổi bộ lọc trạng thái</p>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <div class="px-5 py-4 flex items-center justify-between border-t border-outline-variant/30">
                            <p class="text-sm text-on-surface-variant">
                                Trang <strong>${currentPage}</strong> / ${totalPages}
                                &nbsp;·&nbsp; ${totalRecords} hóa đơn
                            </p>
                            <div class="flex gap-1">
                                <a href="?page=${currentPage-1}&status=${statusFilter}"
                                    class="page-btn ${currentPage == 1 ? 'disabled' : ''}">
                                    <span class="material-symbols-outlined text-[16px]">chevron_left</span>
                                </a>
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <c:if test="${i >= currentPage - 2 && i <= currentPage + 2}">
                                        <a href="?page=${i}&status=${statusFilter}"
                                            class="page-btn ${currentPage == i ? 'active' : ''}">${i}</a>
                                    </c:if>
                                </c:forEach>
                                <a href="?page=${currentPage+1}&status=${statusFilter}"
                                    class="page-btn ${currentPage == totalPages ? 'disabled' : ''}">
                                    <span class="material-symbols-outlined text-[16px]">chevron_right</span>
                                </a>
                            </div>
                        </div>
                    </c:if>
                </div>

                <%@ include file="/views/layout/footer.jsp" %>