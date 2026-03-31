<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/views/layout/header.jsp" %>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

        <div class="container">
            <h2 class="mb-4">
                <i class="bi bi-cup-straw"></i> Quản lý đồ uống
            </h2>

            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle-fill"></i> ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle-fill"></i> ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Form tìm kiếm -->
            <div class="card mb-4">
                <div class="card-header bg-info text-white">
                    <h5 class="mb-0">
                        <i class="bi bi-search"></i> Tìm kiếm đồ uống
                    </h5>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/manager/drinks" method="get" class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label">Tên đồ uống</label>
                            <input type="text" class="form-control" name="searchName" value="${searchName}"
                                placeholder="Nhập tên đồ uống">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Loại đồ uống</label>
                            <select class="form-select" name="categoryId">
                                <option value="0">-- Tất cả --</option>
                                <c:forEach items="${categories}" var="cat">
                                    <option value="${cat.id}" ${selectedCategoryId==cat.id ? 'selected' : '' }>
                                        ${cat.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Trạng thái</label>
                            <select class="form-select" name="status">
                                <option value="">-- Tất cả --</option>
                                <option value="active" ${selectedStatus=='active' ? 'selected' : '' }>Đang bán</option>
                                <option value="inactive" ${selectedStatus=='inactive' ? 'selected' : '' }>Ngừng bán
                                </option>
                            </select>
                        </div>
                        <div class="col-md-2 d-flex align-items-end">
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="bi bi-search"></i> Tìm kiếm
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Nút thêm đồ uống -->
            <div class="mb-3">
                <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addDrinkModal">
                    <i class="bi bi-plus-circle"></i> Thêm đồ uống mới
                </button>
            </div>

            <!-- Danh sách đồ uống -->
            <div class="card">
                <div class="card-header bg-info text-white">
                    <h5 class="mb-0">
                        <i class="bi bi-list"></i> Danh sách đồ uống
                        <span class="badge bg-light text-dark float-end">${totalRecords} sản phẩm</span>
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
                                    <th>Thao tác</th>
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
                                        <td class="text-center">
                                            <a href="${pageContext.request.contextPath}/manager/drinks/edit?id=${drink.id}"
                                                class="btn btn-sm btn-warning" title="Sửa">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                            <form action="${pageContext.request.contextPath}/manager/drinks/delete"
                                                method="post" style="display:inline"
                                                onsubmit="return confirm('Bạn có chắc muốn ẩn đồ uống này?')">
                                                <input type="hidden" name="id" value="${drink.id}">
                                                <button type="submit" class="btn btn-sm btn-danger" title="Ẩn">
                                                    <i class="bi bi-eye-slash"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty drinks}">
                                    <tr>
                                        <td colspan="8" class="text-center text-muted">
                                            <i class="bi bi-inbox"></i> Không tìm thấy đồ uống nào
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>

                    <!-- Phân trang -->
                    <c:if test="${totalPages > 1}">
                        <nav aria-label="Page navigation">
                            <ul class="pagination justify-content-center">
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link"
                                        href="?page=${currentPage-1}&searchName=${searchName}&categoryId=${selectedCategoryId}&status=${selectedStatus}">
                                        <i class="bi bi-chevron-left"></i> Trước
                                    </a>
                                </li>

                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link"
                                            href="?page=${i}&searchName=${searchName}&categoryId=${selectedCategoryId}&status=${selectedStatus}">${i}</a>
                                    </li>
                                </c:forEach>

                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link"
                                        href="?page=${currentPage+1}&searchName=${searchName}&categoryId=${selectedCategoryId}&status=${selectedStatus}">
                                        Sau <i class="bi bi-chevron-right"></i>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Modal Thêm đồ uống -->
        <div class="modal fade" id="addDrinkModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header bg-success text-white">
                        <h5 class="modal-title"><i class="bi bi-plus-circle"></i> Thêm đồ uống mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="${pageContext.request.contextPath}/manager/drinks/add" method="post"
                        enctype="multipart/form-data">
                        <div class="modal-body">
                            <div class="mb-3">
                                <label class="form-label"><span class="text-danger">*</span> Tên đồ uống</label>
                                <input type="text" class="form-control" name="name" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label"><span class="text-danger">*</span> Giá</label>
                                <input type="number" class="form-control" name="price" step="1000" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label"><span class="text-danger">*</span> Danh mục</label>
                                <select class="form-select" name="categoryId" required>
                                    <option value="">-- Chọn danh mục --</option>
                                    <c:forEach items="${categories}" var="cat">
                                        <option value="${cat.id}">${cat.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Mô tả</label>
                                <textarea class="form-control" name="description" rows="3"></textarea>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Hình ảnh</label>
                                <input type="file" class="form-control" name="image" accept="image/*">
                            </div>
                            <div class="mb-3 form-check">
                                <input type="checkbox" class="form-check-input" name="active" checked>
                                <label class="form-check-label">Đang bán</label>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-success"><i class="bi bi-save"></i> Thêm</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>