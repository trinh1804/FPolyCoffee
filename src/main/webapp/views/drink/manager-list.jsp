<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/views/layout/header.jsp" %>

        <h4 class="fw-bold mb-4" style="color:#3d1f0d">
            <i class="bi bi-cup-straw me-2"></i>Quản lý đồ uống
        </h4>

        <c:if test="${not empty message}">
            <div class="alert alert-success alert-dismissible fade show">
                <i class="bi bi-check-circle-fill me-1"></i> ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show">
                <i class="bi bi-exclamation-triangle-fill me-1"></i> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Tìm kiếm -->
        <div class="card shadow-sm border-0 rounded-3 mb-4">
            <div class="card-header card-header-mid py-3 border-0">
                <i class="bi bi-search me-1"></i> Tìm kiếm đồ uống
            </div>
            <div class="card-body p-3">
                <form action="${pageContext.request.contextPath}/manager/drinks" method="get">
                    <div class="row g-2 align-items-end">
                        <div class="col-md-3">
                            <label class="form-label fw-semibold small">Tên đồ uống</label>
                            <input type="text" class="form-control" name="searchName" value="${searchName}"
                                placeholder="Nhập tên đồ uống">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-semibold small">Loại đồ uống</label>
                            <select class="form-select" name="categoryId">
                                <option value="0">-- Tất cả --</option>
                                <c:forEach items="${categories}" var="cat">
                                    <option value="${cat.id}" ${selectedCategoryId==cat.id ? 'selected' : '' }>
                                        ${cat.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-semibold small">Trạng thái</label>
                            <select class="form-select" name="status">
                                <option value="">-- Tất cả --</option>
                                <option value="active" ${selectedStatus=='active' ? 'selected' : '' }>Đang bán</option>
                                <option value="inactive" ${selectedStatus=='inactive' ? 'selected' : '' }>Ngừng bán
                                </option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-semibold small">&nbsp;</label>
                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-coffee flex-grow-1">
                                    <i class="bi bi-search me-1"></i> Tìm
                                </button>
                                <a href="${pageContext.request.contextPath}/manager/drinks"
                                    class="btn btn-outline-secondary flex-grow-1">
                                    <i class="bi bi-arrow-repeat me-1"></i> Làm mới
                                </a>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Nút thêm -->
        <div class="mb-3">
            <button type="button" class="btn btn-coffee" data-bs-toggle="modal" data-bs-target="#addDrinkModal">
                <i class="bi bi-plus-circle me-1"></i> Thêm đồ uống mới
            </button>
        </div>

        <!-- Danh sách -->
        <div class="card shadow-sm border-0 rounded-3">
            <div class="card-header card-header-mid py-3 border-0 d-flex justify-content-between align-items-center">
                <span><i class="bi bi-list me-1"></i> Danh sách đồ uống</span>
                <span class="badge bg-light text-dark">${totalRecords} sản phẩm</span>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr class="text-center">
                                <th>ID</th>
                                <th>Hình</th>
                                <th class="text-start">Tên đồ uống</th>
                                <th>Giá (VNĐ)</th>
                                <th>Danh mục</th>
                                <th class="text-start">Mô tả</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${drinks}" var="drink">
                                <tr>
                                    <td class="text-center text-muted small">${drink.id}</td>
                                    <td class="text-center">
                                        <c:if test="${not empty drink.image}">
                                            <img src="${pageContext.request.contextPath}/uploads/${drink.image}"
                                                class="rounded" style="width:44px;height:44px;object-fit:cover" alt="">
                                        </c:if>
                                        <c:if test="${empty drink.image}">
                                            <div class="rounded bg-light d-inline-flex align-items-center justify-content-center"
                                                style="width:44px;height:44px">
                                                <i class="bi bi-cup text-muted"></i>
                                            </div>
                                        </c:if>
                                    </td>
                                    <td><strong>${drink.name}</strong></td>
                                    <td class="text-end fw-semibold" style="color:#c47c3e;white-space:nowrap">
                                        ${drink.price} ₫
                                    </td>
                                    <td class="text-center">
                                        <c:forEach items="${categories}" var="cat">
                                            <c:if test="${cat.id == drink.categoryId}">
                                                <span class="badge bg-secondary">${cat.name}</span>
                                            </c:if>
                                        </c:forEach>
                                    </td>
                                    <td class="text-muted small" style="max-width:150px">${drink.description}</td>
                                    <td class="text-center">
                                        <span class="badge ${drink.active ? 'bg-success' : 'bg-secondary'}">
                                            <i class="bi ${drink.active ? 'bi-check-circle' : 'bi-x-circle'} me-1"></i>
                                            ${drink.active ? 'Đang bán' : 'Ngừng bán'}
                                        </span>
                                    </td>
                                    <td class="text-center" style="white-space:nowrap">
                                        <a href="${pageContext.request.contextPath}/manager/drinks/edit?id=${drink.id}"
                                            class="btn btn-sm btn-warning" title="Sửa">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                        <form action="${pageContext.request.contextPath}/manager/drinks/delete"
                                            method="post" class="d-inline"
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
                                    <td colspan="8" class="text-center text-muted py-5">
                                        <i class="bi bi-inbox fs-2 d-block mb-2"></i>
                                        Không tìm thấy đồ uống nào
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
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Modal Thêm đồ uống -->
        <div class="modal fade" id="addDrinkModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content border-0 rounded-3">
                    <div class="modal-header card-header-coffee border-0">
                        <h5 class="modal-title"><i class="bi bi-plus-circle me-1"></i> Thêm đồ uống mới</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="${pageContext.request.contextPath}/manager/drinks/add" method="post"
                        enctype="multipart/form-data">
                        <div class="modal-body">
                            <div class="mb-3">
                                <label class="form-label fw-semibold"><span class="text-danger">*</span> Tên đồ
                                    uống</label>
                                <input type="text" class="form-control" name="name" placeholder="Nhập tên đồ uống"
                                    required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-semibold"><span class="text-danger">*</span> Giá
                                    (VNĐ)</label>
                                <input type="number" class="form-control" name="price" step="1000"
                                    placeholder="VD: 35000" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-semibold"><span class="text-danger">*</span> Danh
                                    mục</label>
                                <select class="form-select" name="categoryId" required>
                                    <option value="">-- Chọn danh mục --</option>
                                    <c:forEach items="${categories}" var="cat">
                                        <option value="${cat.id}">${cat.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Mô tả</label>
                                <textarea class="form-control" name="description" rows="3"
                                    placeholder="Mô tả đồ uống..."></textarea>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Hình ảnh</label>
                                <input type="file" class="form-control" name="image" accept="image/*">
                            </div>
                            <div class="form-check">
                                <input type="checkbox" class="form-check-input" name="active" id="activeCheck" checked>
                                <label class="form-check-label" for="activeCheck">Đang bán</label>
                            </div>
                        </div>
                        <div class="modal-footer border-0">
                            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-success">
                                <i class="bi bi-save me-1"></i> Thêm
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>