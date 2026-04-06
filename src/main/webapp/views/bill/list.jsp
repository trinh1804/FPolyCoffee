<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ include file="/views/layout/header.jsp" %>

                <h4 class="fw-bold mb-4" style="color:#3d1f0d">
                    <i class="bi bi-receipt me-2"></i>Quản lý hóa đơn
                </h4>

                <!-- Hiển thị thông báo từ session rồi xóa ngay -->
                <c:if test="${not empty sessionScope.message}">
                    <div class="alert alert-success alert-dismissible fade show">
                        <i class="bi bi-check-circle-fill me-1"></i> ${sessionScope.message}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="message" scope="session" />
                </c:if>
                <c:if test="${not empty sessionScope.error}">
                    <div class="alert alert-danger alert-dismissible fade show">
                        <i class="bi bi-exclamation-triangle-fill me-1"></i> ${sessionScope.error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="error" scope="session" />
                </c:if>

                <!-- Tab lọc theo trạng thái -->
                <ul class="nav nav-tabs mb-4">
                    <li class="nav-item">
                        <a class="nav-link ${statusFilter == -1 ? 'active' : ''}"
                            href="${pageContext.request.contextPath}/manager/bills?status=-1">
                            <i class="bi bi-list-ul me-1"></i> Tất cả
                            <span class="badge bg-secondary ms-1">${totalRecords}</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${statusFilter == 0 ? 'active' : ''}"
                            href="${pageContext.request.contextPath}/manager/bills?status=0">
                            <i class="bi bi-clock-history me-1"></i> Chờ xử lý
                            <span class="badge bg-warning ms-1">${waitingCount}</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${statusFilter == 1 ? 'active' : ''}"
                            href="${pageContext.request.contextPath}/manager/bills?status=1">
                            <i class="bi bi-check-circle me-1"></i> Hoàn thành
                            <span class="badge bg-success ms-1">${finishCount}</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${statusFilter == 2 ? 'active' : ''}"
                            href="${pageContext.request.contextPath}/manager/bills?status=2">
                            <i class="bi bi-x-circle me-1"></i> Đã hủy
                            <span class="badge bg-danger ms-1">${cancelCount}</span>
                        </a>
                    </li>
                </ul>

                <!-- Danh sách hóa đơn -->
                <div class="card shadow-sm border-0 rounded-3">
                    <div
                        class="card-header card-header-mid py-3 border-0 d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-list me-1"></i> Danh sách hóa đơn</span>
                        <span class="badge bg-light text-dark">${totalRecords} hóa đơn</span>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr class="text-center">
                                        <th>ID</th>
                                        <th>Mã đơn</th>
                                        <th>Ngày tạo</th>
                                        <th>Tổng tiền</th>
                                        <th>Giảm giá</th>
                                        <th>Thành tiền</th>
                                        <th>Trạng thái</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${bills}" var="bill">
                                        <tr>
                                            <td class="text-center text-muted small">${bill.id}</td>
                                            <td class="text-center">
                                                <span class="fw-semibold">${bill.code}</span>
                                            </td>
                                            <td class="text-center small">
                                                <fmt:formatDate value="${bill.createdAt}" pattern="dd/MM/yyyy" />
                                            </td>
                                            <td class="text-end fw-semibold">
                                                <fmt:formatNumber value="${bill.totalPrice + bill.discountAmount}"
                                                    pattern="#,##0" /> ₫
                                            </td>
                                            <td class="text-end text-danger small">
                                                -
                                                <fmt:formatNumber value="${bill.discountAmount}" pattern="#,##0" /> ₫
                                            </td>
                                            <td class="text-end fw-bold" style="color:#c47c3e">
                                                <fmt:formatNumber value="${bill.totalPrice}" pattern="#,##0" /> ₫
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${bill.status == 0}">
                                                        <span class="badge bg-warning">
                                                            <i class="bi bi-clock-history me-1"></i> Chờ xử lý
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${bill.status == 1}">
                                                        <span class="badge bg-success">
                                                            <i class="bi bi-check-circle me-1"></i> Hoàn thành
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${bill.status == 2}">
                                                        <span class="badge bg-danger">
                                                            <i class="bi bi-x-circle me-1"></i> Đã hủy
                                                        </span>
                                                    </c:when>
                                                </c:choose>
                                            </td>
                                            <td class="text-center" style="white-space:nowrap">
                                                <a href="${pageContext.request.contextPath}/manager/bills/detail?id=${bill.id}"
                                                    class="btn btn-sm btn-info" title="Xem chi tiết">
                                                    <i class="bi bi-eye"></i>
                                                </a>
                                                <c:if test="${bill.status == 0}">
                                                    <form
                                                        action="${pageContext.request.contextPath}/manager/bills/cancel"
                                                        method="post" class="d-inline"
                                                        onsubmit="return confirm('Bạn có chắc muốn hủy đơn hàng ${bill.code}?')">
                                                        <input type="hidden" name="id" value="${bill.id}">
                                                        <button type="submit" class="btn btn-sm btn-danger"
                                                            title="Hủy đơn">
                                                            <i class="bi bi-x-lg"></i>
                                                        </button>
                                                    </form>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty bills}">
                                        <tr>
                                            <td colspan="8" class="text-center text-muted py-5">
                                                <i class="bi bi-inbox fs-2 d-block mb-2"></i>
                                                Không có hóa đơn nào
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>

                        <!-- Phân trang -->
                        <c:if test="${totalPages > 1}">
                            <div class="p-3">
                                <nav>
                                    <ul class="pagination justify-content-center mb-0">
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <a class="page-link" href="?page=${currentPage-1}&status=${statusFilter}">
                                                <i class="bi bi-chevron-left"></i> Trước
                                            </a>
                                        </li>
                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                <a class="page-link" href="?page=${i}&status=${statusFilter}">${i}</a>
                                            </li>
                                        </c:forEach>
                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <a class="page-link" href="?page=${currentPage+1}&status=${statusFilter}">
                                                Sau <i class="bi bi-chevron-right"></i>
                                            </a>
                                        </li>
                                    </ul>
                                </nav>
                            </div>
                        </c:if>
                    </div>
                </div>

                <%@ include file="/views/layout/footer.jsp" %>