<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<%@ include file="/views/layout/header.jsp" %>

<h1 class="section-title">
    <span class="material-symbols-outlined" style="color:#8B4513">loyalty</span>
    Quản lý điểm thưởng khách hàng
</h1>

<c:if test="${not empty message}">
    <div class="alert alert-success"><span class="material-symbols-outlined text-[18px]">check_circle</span> ${message}</div>
</c:if>
<c:if test="${not empty error}">
    <div class="alert alert-danger"><span class="material-symbols-outlined text-[18px]">error</span> ${error}</div>
</c:if>

<%-- Search --%>
<div class="pc-card mb-6">
    <div class="pc-card-header">
        <span class="material-symbols-outlined text-[18px]" style="color:#8B4513">search</span>
        Tra cứu khách hàng
    </div>
    <div class="p-5">
        <form action="${pageContext.request.contextPath}/manager/customer-points" method="get">
            <div class="flex gap-3 items-end flex-wrap">
                <div class="flex-1 min-w-[200px]">
                    <label class="form-label">Số điện thoại</label>
                    <div class="relative">
                        <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2"
                              style="color:#C6956A;font-size:18px">phone</span>
                        <input type="tel" class="form-control pl-10" name="phone"
                               value="${phone}" placeholder="Nhập SĐT khách hàng..."
                               list="phoneSuggestions" autocomplete="off">
                        <datalist id="phoneSuggestions">
                            <c:forEach items="${allCustomers}" var="c">
                                <option value="${c.phone}">${c.fullName} — ${c.phone}</option>
                            </c:forEach>
                        </datalist>
                    </div>
                </div>
                <button type="submit" class="btn btn-primary px-8 py-2.5">
                    <span class="material-symbols-outlined text-[18px]">search</span> Tra cứu
                </button>
                <a href="${pageContext.request.contextPath}/manager/customer-points"
                   class="btn btn-outline py-2.5">
                    <span class="material-symbols-outlined text-[18px]">refresh</span>
                </a>
            </div>
        </form>
    </div>
</div>

<c:if test="${not empty searchError}">
    <div class="alert alert-warning">
        <span class="material-symbols-outlined text-[18px]">person_search</span> ${searchError}
    </div>
</c:if>

<c:if test="${customer != null}">
    <%-- Customer profile card --%>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-5 mb-6">
        <div class="stat-card">
            <div class="stat-icon" style="background:linear-gradient(135deg,#F5E6D3,#E8D5C0)">
                <span class="material-symbols-outlined" style="color:#8B4513;font-size:28px">person</span>
            </div>
            <div>
                <p style="font-size:0.75rem;font-weight:600;text-transform:uppercase;letter-spacing:0.07em;color:#9E7B5E">
                    Khách hàng
                </p>
                <p style="font-family:'Playfair Display',serif;font-size:1.1rem;font-weight:700;color:#2C1A0E">
                    ${customer.fullName}
                </p>
                <p style="font-size:0.85rem;color:#6B3A1F">${customer.phone}</p>
            </div>
        </div>
        <div class="stat-card" style="background:linear-gradient(135deg,#FFF8E1,#FFF3E0)">
            <div class="stat-icon" style="background:rgba(212,160,23,0.15)">
                <span class="material-symbols-outlined" style="color:#D4A017;font-size:28px">stars</span>
            </div>
            <div>
                <p style="font-size:0.75rem;font-weight:600;text-transform:uppercase;letter-spacing:0.07em;color:#9E7B5E">
                    Điểm hiện tại
                </p>
                <p style="font-family:'Playfair Display',serif;font-size:2rem;font-weight:900;color:#D4A017">
                    ${customer.point}
                </p>
                <p style="font-size:0.8rem;color:#8B6914">≈ <fmt:formatNumber value="${customer.point * 1000}" pattern="#,##0" /> ₫ giảm giá</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">
                <span class="material-symbols-outlined" style="color:#8B4513;font-size:28px">calendar_today</span>
            </div>
            <div>
                <p style="font-size:0.75rem;font-weight:600;text-transform:uppercase;letter-spacing:0.07em;color:#9E7B5E">
                    Thành viên từ
                </p>
                <p style="font-family:'Playfair Display',serif;font-size:1.1rem;font-weight:700;color:#2C1A0E">
                    <fmt:formatDate value="${customer.createdAt}" pattern="dd/MM/yyyy" />
                </p>
                <p style="font-size:0.85rem;color:#6B3A1F">${customer.active ? 'Đang hoạt động' : 'Đã khóa'}</p>
            </div>
        </div>
    </div>

    <%-- Manual adjustment --%>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-5 mb-6">
        <%-- Add points --%>
        <div class="pc-card">
            <div class="pc-card-header" style="background:linear-gradient(135deg,#E8F5E9,#C8E6C9)">
                <span class="material-symbols-outlined" style="color:#2E7D32;font-size:18px">add_circle</span>
                <span style="color:#2E7D32">Cộng điểm thủ công</span>
            </div>
            <div class="p-5">
                <form action="${pageContext.request.contextPath}/manager/customer-points/add-bonus"
                      method="post">
                    <input type="hidden" name="customerId" value="${customer.id}">
                    <div class="mb-4">
                        <label class="form-label">Số điểm cộng</label>
                        <input type="number" class="form-control" name="points"
                               min="1" max="9999" placeholder="VD: 50" required>
                    </div>
                    <div class="mb-4">
                        <label class="form-label">Ghi chú</label>
                        <input type="text" class="form-control" name="note"
                               placeholder="VD: Tặng điểm khai trương...">
                    </div>
                    <button type="submit" class="btn btn-success w-full py-3"
                            onclick="return confirm('Xác nhận cộng điểm cho ${customer.fullName}?')">
                        <span class="material-symbols-outlined text-[18px]">add</span> Cộng điểm
                    </button>
                </form>
            </div>
        </div>

        <%-- Deduct points --%>
        <div class="pc-card">
            <div class="pc-card-header" style="background:linear-gradient(135deg,#FFEBEE,#FFCDD2)">
                <span class="material-symbols-outlined" style="color:#C62828;font-size:18px">remove_circle</span>
                <span style="color:#C62828">Trừ điểm thủ công</span>
            </div>
            <div class="p-5">
                <form action="${pageContext.request.contextPath}/manager/customer-points/deduct"
                      method="post">
                    <input type="hidden" name="customerId" value="${customer.id}">
                    <div class="mb-4">
                        <label class="form-label">Số điểm trừ</label>
                        <input type="number" class="form-control" name="points"
                               min="1" max="${customer.point}" placeholder="VD: 20" required>
                        <p style="font-size:0.78rem;color:#9E7B5E;margin-top:4px">
                            Tối đa: ${customer.point} điểm
                        </p>
                    </div>
                    <button type="submit" class="btn btn-danger w-full py-3"
                            style="padding-top:0.75rem;padding-bottom:0.75rem"
                            onclick="return confirm('Xác nhận trừ điểm?')">
                        <span class="material-symbols-outlined text-[18px]">remove</span> Trừ điểm
                    </button>
                </form>
            </div>
        </div>
    </div>

    <%-- Transaction history --%>
    <div class="pc-card">
        <div class="pc-card-header justify-between">
            <div class="flex items-center gap-2">
                <span class="material-symbols-outlined text-[18px]" style="color:#8B4513">history</span>
                Lịch sử giao dịch điểm
            </div>
            <span class="badge badge-secondary">${history.size()} giao dịch</span>
        </div>
        <div class="overflow-x-auto">
            <table class="data-table w-full">
                <thead>
                    <tr>
                        <th>Ngày</th>
                        <th class="text-center">Cộng điểm</th>
                        <th class="text-center">Trừ điểm</th>
                        <th>Ghi chú</th>
                        <th class="text-center">Mã HĐ</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${history}" var="tx">
                        <tr>
                            <td><fmt:formatDate value="${tx.transactionDate}" pattern="dd/MM/yyyy" /></td>
                            <td class="text-center">
                                <c:if test="${tx.bonusPoint > 0}">
                                    <span class="badge badge-success">+${tx.bonusPoint}</span>
                                </c:if>
                            </td>
                            <td class="text-center">
                                <c:if test="${tx.deductPoint > 0}">
                                    <span class="badge badge-danger">-${tx.deductPoint}</span>
                                </c:if>
                            </td>
                            <td style="font-size:0.85rem;color:#6B3A1F">${tx.note}</td>
                            <td class="text-center">
                                <span class="badge badge-neutral">#${tx.billId}</span>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty history}">
                        <tr>
                            <td colspan="5" class="text-center" style="padding:3rem;color:#9E7B5E">
                                Chưa có giao dịch điểm nào
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</c:if>

<c:if test="${customer == null && empty searchError}">
    <%-- All customers summary table --%>
    <div class="pc-card">
        <div class="pc-card-header justify-between">
            <div class="flex items-center gap-2">
                <span class="material-symbols-outlined text-[18px]" style="color:#8B4513">group</span>
                Tất cả khách hàng có điểm thưởng
            </div>
            <span class="badge badge-secondary">${allCustomers.size()} khách</span>
        </div>
        <div class="overflow-x-auto">
            <table class="data-table w-full">
                <thead>
                    <tr>
                        <th>Họ tên</th>
                        <th>Số điện thoại</th>
                        <th class="text-center">Điểm hiện tại</th>
                        <th class="text-center">Ngày tham gia</th>
                        <th class="text-center">Xem chi tiết</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${allCustomers}" var="c">
                        <tr>
                            <td class="font-semibold">${c.fullName}</td>
                            <td style="font-family:monospace">${c.phone}</td>
                            <td class="text-center">
                                <c:choose>
                                    <c:when test="${c.point > 0}">
                                        <span class="badge badge-gold">
                                            <span class="material-symbols-outlined text-[12px]">stars</span>
                                            ${c.point}
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color:#C6956A;font-size:0.85rem">0</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center" style="font-size:0.85rem;color:#6B3A1F">
                                <fmt:formatDate value="${c.createdAt}" pattern="dd/MM/yyyy" />
                            </td>
                            <td class="text-center">
                                <a href="${pageContext.request.contextPath}/manager/customer-points?phone=${c.phone}"
                                   class="btn btn-secondary btn-sm">
                                    <span class="material-symbols-outlined text-[14px]">open_in_new</span>
                                    Xem
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</c:if>

<%@ include file="/views/layout/footer.jsp" %>
