<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/views/layout/header.jsp" %>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        <div class="container">
            <h2 class="mb-4">
                <i class="bi bi-tags"></i> Quản lý danh mục đồ uống
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

            <div class="row">
                <div class="col-md-4 mb-4">
                    <div class="card">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0">
                                <c:if test="${category == null}">
                                    <i class="bi bi-plus-circle"></i> Thêm danh mục mới
                                </c:if>
                                <c:if test="${category != null}">
                                    <i class="bi bi-pencil-square"></i> Cập nhật danh mục
                                </c:if>
                            </h5>
                        </div>
                        <div class="card-body">
                            <form
                                action="${pageContext.request.contextPath}/manager/categories${category != null ? '/edit' : '/add'}"
                                method="post" enctype="multipart/form-data">
                                <c:if test="${category != null}">
                                    <input type="hidden" name="id" value="${category.id}">
                                </c:if>

                                <div class="mb-3">
                                    <label for="name" class="form-label">
                                        <span class="text-danger">*</span> Tên danh mục
                                    </label>
                                    <input type="text" class="form-control" id="name" name="name"
                                        value="${category != null ? category.name : ''}" placeholder="Nhập tên danh mục"
                                        required>
                                </div>

                                <div class="mb-3">
                                    <label for="description" class="form-label">Mô tả</label>
                                    <textarea class="form-control" id="description" name="description" rows="3"
                                        placeholder="Mô tả về danh mục">${category != null ? category.description : ''}</textarea>
                                </div>

                                <div class="mb-3">
                                    <label for="image" class="form-label">Hình ảnh</label>
                                    <input type="file" class="form-control" id="image" name="image" accept="image/*">
                                    <small class="text-muted">Định dạng: JPG, PNG, GIF (tối đa 5MB)</small>
                                    <c:if test="${category != null && not empty category.image}">
                                        <div class="mt-2">
                                            <img src="${pageContext.request.contextPath}/uploads/${category.image}"
                                                style="max-height: 80px" class="img-thumbnail" alt="Hình hiện tại">
                                            <span class="text-muted small d-block">Hình hiện tại (giữ nguyên nếu không
                                                chọn
                                                ảnh mới)</span>
                                        </div>
                                    </c:if>
                                </div>

                                <div class="d-grid gap-2">
                                    <button type="submit" class="btn btn-primary">
                                        <c:if test="${category == null}">
                                            <i class="bi bi-save"></i> Thêm mới
                                        </c:if>
                                        <c:if test="${category != null}">
                                            <i class="bi bi-update"></i> Cập nhật
                                        </c:if>
                                    </button>
                                    <c:if test="${category != null}">
                                        <a href="${pageContext.request.contextPath}/manager/categories"
                                            class="btn btn-secondary">
                                            <i class="bi bi-arrow-left"></i> Hủy
                                        </a>
                                    </c:if>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="col-md-8">
                    <div class="card">
                        <div class="card-header bg-info text-white">
                            <h5 class="mb-0">
                                <i class="bi bi-list"></i> Danh sách danh mục
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-bordered table-hover">
                                    <thead class="table-light">
                                        <tr class="text-center">
                                            <th>ID</th>
                                            <th>Hình ảnh</th>
                                            <th>Tên danh mục</th>
                                            <th>Mô tả</th>
                                            <th>Trạng thái</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${list}" var="cat">
                                            <tr>
                                                <td class="text-center">${cat.id}</td>
                                                <td class="text-center">
                                                    <c:if test="${not empty cat.image}">
                                                        <img src="${pageContext.request.contextPath}/uploads/${cat.image}"
                                                            style="max-height: 50px; max-width: 50px;"
                                                            class="img-thumbnail" alt="Hình">
                                                    </c:if>
                                                    <c:if test="${empty cat.image}">
                                                        <span class="text-muted">Chưa có ảnh</span>
                                                    </c:if>
                                                </td>
                                                <td><strong>${cat.name}</strong></td>
                                                <td>${cat.description}</td>
                                                <td class="text-center">
                                                    <span class="badge ${cat.active ? 'bg-success' : 'bg-secondary'}">
                                                        <i
                                                            class="bi ${cat.active ? 'bi-check-circle' : 'bi-x-circle'}"></i>
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
                                                        method="post" style="display:inline"
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
                                                <td colspan="6" class="text-center text-muted">
                                                    <i class="bi bi-inbox"></i> Chưa có danh mục nào
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
        </div>
        <%@ include file="/views/layout/footer.jsp" %>