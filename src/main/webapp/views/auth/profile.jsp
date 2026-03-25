<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/views/layout/header.jsp" %>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        <h2 class="mb-4">
            <i class="bi bi-person-circle"></i> Thông tin cá nhân
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

        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">
                            <i class="bi bi-pencil-square"></i> Cập nhật thông tin
                        </h5>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/thong-tin-ca-nhan" method="post">
                            <div class="mb-3">
                                <label for="fullName" class="form-label">
                                    <span class="text-danger">*</span> Họ và tên
                                </label>
                                <input type="text" class="form-control" id="fullName" name="fullName"
                                    value="${sessionScope.user.fullName}" required>
                                <c:if test="${not empty fullNameError}">
                                    <div class="text-danger mt-1">${fullNameError}</div>
                                </c:if>
                            </div>

                            <div class="mb-3">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" value="${sessionScope.user.email}"
                                    readonly disabled>
                                <small class="text-muted">Email không thể thay đổi</small>
                            </div>

                            <div class="mb-3">
                                <label for="phone" class="form-label">
                                    <span class="text-danger">*</span> Số điện thoại
                                </label>
                                <input type="tel" class="form-control" id="phone" name="phone"
                                    value="${sessionScope.user.phone}" placeholder="0xxxxxxxxx" required>
                                <c:if test="${not empty phoneError}">
                                    <div class="text-danger mt-1">${phoneError}</div>
                                </c:if>
                                <small class="text-muted">Số điện thoại phải bắt đầu bằng 0 và có 10 chữ số</small>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Vai trò</label>
                                <div>
                                    <c:if test="${sessionScope.user.roleId == 1}">
                                        <span class="badge bg-danger">Quản trị viên</span>
                                    </c:if>
                                    <c:if test="${sessionScope.user.roleId == 2}">
                                        <span class="badge bg-info">Nhân viên</span>
                                    </c:if>
                                </div>
                            </div>

                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-save"></i> Cập nhật thông tin
                                </button>
                                <a href="${pageContext.request.contextPath}/doi-mat-khau"
                                    class="btn btn-outline-secondary">
                                    <i class="bi bi-key"></i> Đổi mật khẩu
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="/views/layout/footer.jsp" %>