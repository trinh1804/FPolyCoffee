<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ include file="/views/layout/header.jsp" %>

                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h4 class="fw-bold" style="color:#3d1f0d">
                        <i class="bi bi-receipt me-2"></i>Chi tiết hóa đơn
                    </h4>
                    <a href="${pageContext.request.contextPath}/manager/bills" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left me-1"></i> Quay lại
                    </a>
                </div>

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
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show">
                        <i class="bi bi-exclamation-triangle-fill me-1"></i> ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${bill != null}">
                    <div class="row g-4">
                        <!-- Thông tin hóa đơn -->
                        <div class="col-md-5">
                            <div class="card shadow-sm border-0 rounded-3">
                                <div class="card-header card-header-coffee py-3 border-0">
                                    <i class="bi bi-info-circle me-1"></i> Thông tin hóa đơn
                                </div>
                                <div class="card-body">
                                    <table class="table table-borderless">
                                        <tr>
                                            <td style="width: 120px"><strong>Mã đơn:</strong></td>
                                            <td><span class="fw-semibold">${bill.code}</span></td>
                                        </tr>
                                        <tr>
                                            <td><strong>Ngày tạo:</strong></td>
                                            <td>
                                                <fmt:formatDate value="${bill.createdAt}" pattern="dd/MM/yyyy" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><strong>Nhân viên:</strong></td>
                                            <td>${staffName}</td>
                                        </tr>
                                        <tr>
                                            <td><strong>Phương thức:</strong></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${bill.paymentMethod}">
                                                        <span class="badge bg-info">Chuyển khoản</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">Tiền mặt</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><strong>Trạng thái:</strong></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${bill.status == 0}">
                                                        <span class="badge bg-warning">Chờ xử lý</span>
                                                    </c:when>
                                                    <c:when test="${bill.status == 1}">
                                                        <span class="badge bg-success">Hoàn thành</span>
                                                    </c:when>
                                                    <c:when test="${bill.status == 2}">
                                                        <span class="badge bg-danger">Đã hủy</span>
                                                    </c:when>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <!-- Tổng kết -->
                        <div class="col-md-7">
                            <div class="card shadow-sm border-0 rounded-3">
                                <div class="card-header card-header-gold py-3 border-0">
                                    <i class="bi bi-calculator me-1"></i> Tổng kết
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-6">
                                            <p class="text-muted mb-1">Tạm tính:</p>
                                            <h5 class="fw-bold">
                                                <fmt:formatNumber value="${bill.totalPrice + bill.discountAmount}"
                                                    pattern="#,##0" /> ₫
                                            </h5>
                                        </div>
                                        <div class="col-6">
                                            <p class="text-muted mb-1">Giảm giá:</p>
                                            <h5 class="fw-bold text-danger">
                                                -
                                                <fmt:formatNumber value="${bill.discountAmount}" pattern="#,##0" /> ₫
                                            </h5>
                                        </div>
                                    </div>
                                    <hr>
                                    <div class="row">
                                        <div class="col-12">
                                            <p class="text-muted mb-1">Thành tiền:</p>
                                            <h3 class="fw-bold" style="color:#c47c3e">
                                                <fmt:formatNumber value="${bill.totalPrice}" pattern="#,##0" /> ₫
                                            </h3>
                                        </div>
                                    </div>

                                    <c:if test="${bill.status == 0}">
                                        <div class="mt-3 d-flex gap-2">
                                            <form action="${pageContext.request.contextPath}/manager/bills/complete"
                                                method="post" class="flex-grow-1"
                                                onsubmit="return confirm('Xác nhận hoàn thành đơn hàng ${bill.code}?')">
                                                <input type="hidden" name="id" value="${bill.id}">
                                                <button type="submit" class="btn btn-success w-100">
                                                    <i class="bi bi-check-lg me-1"></i> Hoàn thành đơn
                                                </button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/manager/bills/cancel"
                                                method="post" class="flex-grow-1"
                                                onsubmit="return confirm('Bạn có chắc muốn hủy đơn hàng ${bill.code}?')">
                                                <input type="hidden" name="id" value="${bill.id}">
                                                <button type="submit" class="btn btn-danger w-100">
                                                    <i class="bi bi-x-lg me-1"></i> Hủy đơn hàng
                                                </button>
                                            </form>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <!-- Danh sách sản phẩm -->
                        <div class="col-12">
                            <div class="card shadow-sm border-0 rounded-3">
                                <div class="card-header card-header-mid py-3 border-0">
                                    <i class="bi bi-cup-straw me-1"></i> Danh sách sản phẩm
                                </div>
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle mb-0">
                                            <thead class="table-light">
                                                <tr class="text-center">
                                                    <th>STT</th>
                                                    <th class="text-start">Tên sản phẩm</th>
                                                    <th>Số lượng</th>
                                                    <th>Đơn giá</th>
                                                    <th>Thành tiền</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${items}" var="item" varStatus="loop">
                                                    <tr>
                                                        <td class="text-center text-muted">${loop.index + 1}</td>
                                                        <td class="fw-semibold">${item.drinkName}</td>
                                                        <td class="text-center">${item.quantity}</td>
                                                        <td class="text-end">
                                                            <fmt:formatNumber value="${item.unitPrice}"
                                                                pattern="#,##0" /> ₫
                                                        </td>
                                                        <td class="text-end fw-semibold" style="color:#c47c3e">
                                                            <fmt:formatNumber value="${item.totalPrice}"
                                                                pattern="#,##0" /> ₫
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty items}">
                                                    <tr>
                                                        <td colspan="5" class="text-center text-muted py-4">
                                                            <i class="bi bi-inbox fs-2 d-block mb-2"></i>
                                                            Không có sản phẩm nào
                                                        </td>
                                                    </tr>
                                                </c:if>
                                            </tbody>
                                            <tfoot class="table-light">
                                                <tr>
                                                    <td colspan="4" class="text-end fw-bold">Tổng cộng:</td>
                                                    <td class="text-end fw-bold" style="color:#c47c3e">
                                                        <fmt:formatNumber value="${bill.totalPrice}" pattern="#,##0" />
                                                        ₫
                                                    </td>
                                                </tr>
                                            </tfoot>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>
                <%@ include file="/views/layout/footer.jsp" %>