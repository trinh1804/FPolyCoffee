<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<%@ include file="/views/layout/header.jsp" %>

<div class="flex items-center justify-between mb-6">
    <h1 class="section-title mb-0">
        <span class="material-symbols-outlined text-primary">receipt_long</span>
        Phiếu bán hàng của tôi
    </h1>
    <a href="${pageContext.request.contextPath}/employee/bills/create" class="btn btn-primary">
        <span class="material-symbols-outlined text-[18px]">add_circle</span>
        Tạo phiếu mới
    </a>
</div>

<c:if test="${not empty message}">
    <div class="alert alert-success">
        <span class="material-symbols-outlined text-[18px]">check_circle</span> ${message}
    </div>
</c:if>
<c:if test="${not empty error}">
    <div class="alert alert-danger">
        <span class="material-symbols-outlined text-[18px]">error</span> ${error}
    </div>
</c:if>

<div class="pc-card">
    <div class="pc-card-header justify-between">
        <div class="flex items-center gap-2">
            <span class="material-symbols-outlined text-primary text-[18px]">list</span>
            Danh sách phiếu
        </div>
        <span class="badge badge-secondary">${bills.size()} phiếu</span>
    </div>
    <div class="overflow-x-auto">
        <table class="data-table w-full">
            <thead>
                <tr>
                    <th>Mã phiếu</th>
                    <th>Ngày tạo</th>
                    <th class="text-right">Tổng tiền</th>
                    <th class="text-center">Thanh toán</th>
                    <th class="text-center">Trạng thái</th>
                    <th class="text-center">Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${bills}" var="bill">
                    <tr>
                        <td class="font-headline font-bold text-primary">${bill.code}</td>
                        <td>
                            <fmt:formatDate value="${bill.createdAt}" pattern="dd/MM/yyyy" />
                        </td>
                        <td class="text-right font-bold text-primary">
                            <fmt:formatNumber value="${bill.totalPrice}" pattern="#,##0" /> ₫
                        </td>
                        <td class="text-center">
                            <c:choose>
                                <c:when test="${bill.paymentMethod}">
                                    <span class="badge badge-info">
                                        <span class="material-symbols-outlined text-[13px]">account_balance</span>
                                        Online
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-secondary">
                                        <span class="material-symbols-outlined text-[13px]">payments</span>
                                        Tiền mặt
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-center">
                            <c:choose>
                                <c:when test="${bill.status == 0}">
                                    <span class="badge badge-warning">
                                        <span class="material-symbols-outlined text-[13px]">pending</span>
                                        Đang xử lý
                                    </span>
                                </c:when>
                                <c:when test="${bill.status == 1}">
                                    <span class="badge badge-success">
                                        <span class="material-symbols-outlined text-[13px]">check_circle</span>
                                        Hoàn thành
                                    </span>
                                </c:when>
                                <c:when test="${bill.status == 2}">
                                    <span class="badge badge-danger">
                                        <span class="material-symbols-outlined text-[13px]">cancel</span>
                                        Đã hủy
                                    </span>
                                </c:when>
                            </c:choose>
                        </td>
                        <td class="text-center">
                            <div class="flex items-center justify-center gap-2">
                                <c:if test="${bill.status == 0}">
                                    <a href="${pageContext.request.contextPath}/employee/bills/order?id=${bill.id}"
                                       class="btn btn-primary btn-sm">
                                        <span class="material-symbols-outlined text-[15px]">edit</span>
                                        Mở phiếu
                                    </a>
                                    <form action="${pageContext.request.contextPath}/employee/bills/cancel"
                                          method="post" class="inline"
                                          onsubmit="return confirm('Hủy phiếu ${bill.code}?')">
                                        <input type="hidden" name="billId" value="${bill.id}">
                                        <button type="submit" class="btn btn-danger btn-sm">
                                            <span class="material-symbols-outlined text-[15px]">close</span>
                                        </button>
                                    </form>
                                </c:if>
                                <c:if test="${bill.status != 0}">
                                    <span class="text-on-surface-variant text-sm italic">—</span>
                                </c:if>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty bills}">
                    <tr>
                        <td colspan="6" class="text-center py-16 text-on-surface-variant">
                            <span class="material-symbols-outlined block mb-3 opacity-25"
                                  style="font-size:4rem">receipt_long</span>
                            <p class="font-semibold mb-1">Bạn chưa có phiếu nào</p>
                            <p class="text-sm opacity-60">Nhấn "Tạo phiếu mới" để bắt đầu</p>
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/views/layout/footer.jsp" %>
