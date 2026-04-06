<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/views/layout/header.jsp" %>

        <h4 class="fw-bold mb-4" style="color:#3d1f0d">
            <i class="bi bi-tags me-2"></i>Quản lý danh mục đồ uống
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

        <div class="row g-4">

            <!-- Form thêm / sửa -->
            <div class="col-md-4">
                <div class="card shadow-sm border-0 rounded-3">
                    <div class="card-header card-header-coffee py-3 border-0">
                        <c:if test="${category == null}">
                            <i class="bi bi-plus-circle me-1"></i> Thêm danh mục mới
                        </c:if>
                        <c:if test="${category != null}">
                            <i class="bi bi-pencil-square me-1"></i> Cập nhật danh mục
                        </c:if>
                    </div>
                    <div class="card-body p-4">
                        <form
                            action="${pageContext.request.contextPath}/manager/categories${category != null ? '/edit' : '/add'}"
                            method="post" enctype="multipart/form-data">

                            <c:if test="${category != null}">
                                <input type="hidden" name="id" value="${category.id}">
                            </c:if>

                            <div class="mb-3">
                                <label for="name" class="form-label fw-semibold">
                                    <span class="text-danger">*</span> Tên danh mục
                                </label>
                                <input type="text" class="form-control" id="name" name="name"
                                    value="${category != null ? category.name : ''}" placeholder="Nhập tên danh mục"
                                    required>
                            </div>

                            <div class="mb-3">
                                <label for="description" class="form-label fw-semibold">Mô tả</label>
                                <textarea class="form-control" id="description" name="description" rows="3"
                                    placeholder="Mô tả về danh mục">${category != null ? category.description : ''}</textarea>
                            </div>

                            <div class="mb-4">
                                <label for="image" class="form-label fw-semibold">Hình ảnh</label>
                                <input type="file" class="form-control" id="image" name="image" accept="image/*">
                                <div class="form-text">JPG, PNG, GIF — tối đa 5MB</div>
                                <c:if test="${category != null && not empty category.image}">
                                    <div class="mt-2">
                                        <img src="${pageContext.request.contextPath}/uploads/${category.image}"
                                            class="img-thumbnail" style="max-height:70px" alt="Hình hiện tại">
                                        <div class="form-text">Hình hiện tại (giữ nguyên nếu không chọn ảnh mới)</div>
                                    </div>
                                </c:if>
                            </div>

                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-coffee">
                                    <c:if test="${category == null}"><i class="bi bi-save me-1"></i> Thêm mới</c:if>
                                    <c:if test="${category != null}"><i class="bi bi-check-lg me-1"></i> Cập nhật</c:if>
                                </button>
                                <c:if test="${category != null}">
                                    <a href="${pageContext.request.contextPath}/manager/categories"
                                        class="btn btn-outline-secondary">
                                        <i class="bi bi-x-lg me-1"></i> Hủy
                                    </a>
                                </c:if>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Danh sách -->
            <div class="col-md-8">
                <div class="card shadow-sm border-0 rounded-3">
                    <div class="card-header card-header-mid py-3 border-0">
                        <i class="bi bi-list me-1"></i> Danh sách danh mục
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr class="text-center">
                                        <th>ID</th>
                                        <th>Hình</th>
                                        <th class="text-start">Tên danh mục</th>
                                        <th class="text-start">Mô tả</th>
                                        <th>Trạng thái</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${list}" var="cat">
                                        <tr>
                                            <td class="text-center text-muted small">${cat.id}</td>
                                            <td class="text-center">
                                                <c:if test="${not empty cat.image}">
                                                    <img src="${pageContext.request.contextPath}/uploads/${cat.image}"
                                                        class="rounded" style="width:44px;height:44px;object-fit:cover"
                                                        alt="">
                                                </c:if>
                                                <c:if test="${empty cat.image}">
                                                    <div class="rounded bg-light d-inline-flex align-items-center justify-content-center"
                                                        style="width:44px;height:44px">
                                                        <i class="bi bi-image text-muted"></i>
                                                    </div>
                                                </c:if>
                                            </td>
                                            <td><strong>${cat.name}</strong></td>
                                            <td class="text-muted small">${cat.description}</td>
                                            <td class="text-center">
                                                <span class="badge ${cat.active ? 'bg-success' : 'bg-secondary'}">
                                                    <i
                                                        class="bi ${cat.active ? 'bi-check-circle' : 'bi-x-circle'} me-1"></i>
                                                    ${cat.active ? 'Hoạt động' : 'Ẩn'}
                                                </span>
                                            </td>
                                            <td class="text-center">
                                                <a href="${pageContext.request.contextPath}/manager/categories?id=${cat.id}"
                                                    class="btn btn-sm btn-warning" title="Sửa">
                                                    <i class="bi bi-pencil"></i>
                                                </a>
                                                <form
                                                    action="${pageContext.request.contextPath}/manager/categories/delete"
                                                    method="post" class="d-inline"
                                                    onsubmit="return confirm('Bạn có chắc chắn muốn xóa danh mục này?')">
                                                    <input type="hidden" name="id" value="${cat.id}">
                                                    <button type="submit" class="btn btn-sm btn-danger" title="Xóa">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty list}">
                                        <tr>
                                            <td colspan="6" class="text-center text-muted py-5">
                                                <i class="bi bi-inbox fs-2 d-block mb-2"></i>
                                                Chưa có danh mục nào
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <%@ include file="/views/layout/footer.jsp" %>