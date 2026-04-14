<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ include file="/views/layout/header.jsp" %>

                <div class="flex items-center justify-between mb-6">
                    <h1 class="section-title mb-0">
                        <span class="material-symbols-outlined text-primary">receipt_long</span>
                        Chi tiết hóa đơn
                    </h1>
                    <a href="${pageContext.request.contextPath}/manager/bills" class="btn btn-outline">
                        <span class="material-symbols-outlined text-[18px]">arrow_back</span>
                        Quay lại
                    </a>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger"><span class="material-symbols-outlined text-[18px]">error</span>
                        ${error}</div>
                </c:if>

                <c:if test="${bill != null}">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                        <!-- Bill info -->
                        <div class="pc-card">
                            <div class="pc-card-header">
                                <span class="material-symbols-outlined text-primary text-[18px]">info</span>
                                Thông tin hóa đơn
                            </div>
                            <div class="p-6 space-y-4">
                                <div class="flex justify-between items-center">
                                    <span class="text-sm text-on-surface-variant">Mã đơn</span>
                                    <span class="font-headline font-bold text-primary">${bill.code}</span>
                                </div>
                                <div class="flex justify-between items-center">
                                    <span class="text-sm text-on-surface-variant">Ngày tạo</span>
                                    <span class="text-sm font-medium">
                                        <fmt:formatDate value="${bill.createdAt}" pattern="dd/MM/yyyy HH:mm:ss" />
                                    </span>
                                </div>
                                <div class="flex justify-between items-center">
                                    <span class="text-sm text-on-surface-variant">Nhân viên</span>
                                    <span class="text-sm font-medium">${staffName}</span>
                                </div>
                                <div class="flex justify-between items-center">
                                    <span class="text-sm text-on-surface-variant">Phương thức</span>
                                    <c:choose>
                                        <c:when test="${bill.paymentMethod}">
                                            <span class="badge badge-info"><span
                                                    class="material-symbols-outlined text-[14px]">account_balance</span>Chuyển
                                                khoản</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-secondary"><span
                                                    class="material-symbols-outlined text-[14px]">payments</span>Tiền
                                                mặt</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="flex justify-between items-center">
                                    <span class="text-sm text-on-surface-variant">Trạng thái</span>
                                    <c:choose>
                                        <c:when test="${bill.status == 0}">
                                            <span class="badge badge-warning"><span
                                                    class="material-symbols-outlined text-[14px]">pending</span>Chờ xử
                                                lý</span>
                                        </c:when>
                                        <c:when test="${bill.status == 1}">
                                            <span class="badge badge-success"><span
                                                    class="material-symbols-outlined text-[14px]">check_circle</span>Hoàn
                                                thành</span>
                                        </c:when>
                                        <c:when test="${bill.status == 2}">
                                            <span class="badge badge-danger"><span
                                                    class="material-symbols-outlined text-[14px]">cancel</span>Đã
                                                hủy</span>
                                        </c:when>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <!-- Summary -->
                        <div class="pc-card">
                            <div class="pc-card-header">
                                <span class="material-symbols-outlined text-primary text-[18px]">calculate</span>
                                Tổng kết
                            </div>
                            <div class="p-6">
                                <div class="grid grid-cols-2 gap-4 mb-4">
                                    <div class="p-4 rounded-xl bg-surface-container-low">
                                        <p class="text-xs text-on-surface-variant mb-1">Tạm tính</p>
                                        <p class="font-headline font-bold text-lg text-on-surface">
                                            <fmt:formatNumber value="${bill.totalPrice + bill.discountAmount}"
                                                pattern="#,##0" /> ₫
                                        </p>
                                    </div>
                                    <div class="p-4 rounded-xl bg-error-container">
                                        <p class="text-xs text-error mb-1">Giảm giá</p>
                                        <p class="font-headline font-bold text-lg text-error">
                                            -
                                            <fmt:formatNumber value="${bill.discountAmount}" pattern="#,##0" /> ₫
                                        </p>
                                    </div>
                                </div>
                                <div class="p-4 rounded-xl"
                                    style="background: linear-gradient(135deg, #ffdbc9, #ffb68c);">
                                    <p class="text-xs text-primary mb-1">Thành tiền</p>
                                    <p class="font-headline font-black text-2xl text-primary">
                                        <fmt:formatNumber value="${bill.totalPrice}" pattern="#,##0" /> ₫
                                    </p>
                                </div>

                                <c:if test="${bill.status == 0}">
                                    <div class="flex gap-3 mt-5">
                                        <form action="${pageContext.request.contextPath}/manager/bills/complete"
                                            method="post" class="flex-1"
                                            onsubmit="return confirm('Xác nhận hoàn thành đơn hàng ${bill.code}?')">
                                            <input type="hidden" name="id" value="${bill.id}">
                                            <button type="submit" class="btn btn-primary w-full py-3">
                                                <span class="material-symbols-outlined text-[18px]">check_circle</span>
                                                Hoàn thành
                                            </button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/manager/bills/cancel"
                                            method="post" class="flex-1"
                                            onsubmit="return confirm('Hủy đơn hàng ${bill.code}?')">
                                            <input type="hidden" name="id" value="${bill.id}">
                                            <button type="submit" class="btn btn-danger w-full py-3">
                                                <span class="material-symbols-outlined text-[18px]">cancel</span> Hủy
                                                đơn
                                            </button>
                                        </form>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <!-- Products table -->
                    <div class="pc-card">
                        <div class="pc-card-header">
                            <span class="material-symbols-outlined text-primary text-[18px]">shopping_bag</span>
                            Danh sách sản phẩm
                        </div>
                        <div class="overflow-x-auto">
                            <table class="data-table w-full">
                                <thead>
                                    <tr>
                                        <th class="text-center">STT</th>
                                        <th>Tên sản phẩm</th>
                                        <th class="text-center">Số lượng</th>
                                        <th class="text-right">Đơn giá</th>
                                        <th class="text-right">Thành tiền</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${items}" var="item" varStatus="loop">
                                        <tr>
                                            <td class="text-center text-on-surface-variant text-sm">${loop.index + 1}
                                            </td>
                                            <td class="font-semibold">${item.drinkName}</td>
                                            <td class="text-center">
                                                <span class="badge badge-info">${item.quantity}</span>
                                            </td>
                                            <td class="text-right text-sm text-on-surface-variant">
                                                <fmt:formatNumber value="${item.unitPrice}" pattern="#,##0" /> ₫
                                            </td>
                                            <td class="text-right font-bold text-primary">
                                                <fmt:formatNumber value="${item.totalPrice}" pattern="#,##0" /> ₫
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty items}">
                                        <tr>
                                            <td colspan="5" class="text-center py-10 text-on-surface-variant">
                                                <span
                                                    class="material-symbols-outlined text-4xl block mb-2 opacity-30">inbox</span>
                                                Không có sản phẩm nào
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                                <tfoot>
                                    <tr style="background: #fdf6f0;">
                                        <td colspan="4" class="text-right font-bold text-on-surface py-3 px-4">Tổng
                                            cộng:</td>
                                        <td class="text-right font-black text-primary py-3 px-4 text-lg">
                                            <fmt:formatNumber value="${bill.totalPrice}" pattern="#,##0" /> ₫
                                        </td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                </c:if>

                <%@ include file="/views/layout/footer.jsp" %>