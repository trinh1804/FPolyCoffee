<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/views/layout/header.jsp" %>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        <div class="container">
            <h2 class="mb-4">
                <i class="bi bi-cup-straw"></i> Quản lý đồ uống
            </h2>

            <div class="alert alert-info">
                <i class="bi bi-info-circle-fill"></i>
                <strong>Chức năng đang phát triển</strong> - Đây là trang quản lý đồ uống
            </div>

            <div class="card">
                <div class="card-header bg-info text-white">
                    <h5 class="mb-0">
                        <i class="bi bi-list"></i> Danh sách đồ uống
                        <span class="badge bg-light text-dark float-end">${drinks.size()} sản phẩm</span>
                    </h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover">
                            <thead class="table-light">
                                <tr class="text-center">
                                    <th>ID</th>
                                    <th>Hình ảnh</th>
                                    <th>Tên đồ uống</th>
                                    <th>Giá (VNĐ)</th>
                                    <th>Danh mục</th>
                                    <th>Mô tả</th>
                                    <th>Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${drinks}" var="drink">
                                    <tr>
                                        <td class="text-center">${drink.id}</td>
                                        <td class="text-center">
                                            <c:if test="${not empty drink.image}">
                                                <img src="${pageContext.request.contextPath}/uploads/${drink.image}"
                                                    style="max-height: 50px; max-width: 50px;" class="img-thumbnail"
                                                    alt="Hình">
                                            </c:if>
                                            <c:if test="${empty drink.image}">
                                                <span class="text-muted">Chưa có ảnh</span>
                                            </c:if>
                                        </td>
                                        <td><strong>${drink.name}</strong></td>
                                        <td class="text-end">${drink.price} ₫</td>
                                        <td>
                                            <c:forEach items="${categories}" var="cat">
                                                <c:if test="${cat.id == drink.categoryId}">
                                                    <span class="badge bg-secondary">${cat.name}</span>
                                                </c:if>
                                            </c:forEach>
                                        </td>
                                        <td>${drink.description}</td>
                                        <td class="text-center">
                                            <span class="badge ${drink.active ? 'bg-success' : 'bg-secondary'}">
                                                <i class="bi ${drink.active ? 'bi-check-circle' : 'bi-x-circle'}"></i>
                                                ${drink.active ? 'Đang bán' : 'Ngừng bán'}
                                            </span>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty drinks}">
                                    <tr>
                                        <td colspan="7" class="text-center text-muted">
                                            <i class="bi bi-inbox"></i> Chưa có đồ uống nào
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <%@ include file="/views/layout/footer.jsp" %>