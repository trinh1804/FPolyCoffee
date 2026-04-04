<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/views/layout/header.jsp" %>

        <div class="row justify-content-center">
            <div class="col-md-7 col-lg-6">

                <h4 class="fw-bold mb-4" style="color:#3d1f0d">
                    <i class="bi bi-person-circle me-2"></i>Thông tin cá nhân
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

                <div class="card shadow-sm border-0 rounded-3">
                    <div class="card-header card-header-coffee py-3 border-0">
                        <i class="bi bi-pencil-square me-1"></i> Cập nhật thông tin
                    </div>
                    <div class="card-body p-4">
                        <form action="${pageContext.request.contextPath}/thong-tin-ca-nhan" method="post">

                            <div class="mb-3">
                                <label for="fullName" class="form-label fw-semibold">
                                    <span class="text-danger">*</span> Họ và tên
                                </label>
                                <input type="text" class="form-control" id="fullName" name="fullName"
                                    value="${sessionScope.user.fullName}" required>
                                <c:if test="${not empty fullNameError}">
                                    <div class="text-danger small mt-1">${fullNameError}</div>
                                </c:if>
                            </div>

                            <div class="mb-3">
                                <label for="email" class="form-label fw-semibold">Email</label>
                                <input type="email" class="form-control" id="email" value="${sessionScope.user.email}"
                                    readonly disabled>
                                <div class="form-text">Email không thể thay đổi</div>
                            </div>

                            <div class="mb-3">
                                <label for="phone" class="form-label fw-semibold">
                                    <span class="text-danger">*</span> Số điện thoại
                                </label>
                                <input type="tel" class="form-control" id="phone" name="phone"
                                    value="${sessionScope.user.phone}" placeholder="0xxxxxxxxx" required>
                                <c:if test="${not empty phoneError}">
                                    <div class="text-danger small mt-1">${phoneError}</div>
                                </c:if>
                                <div class="form-text">Phải bắt đầu bằng 0 và có 10 chữ số</div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-semibold">Vai trò</label><br>
                                <c:if test="${sessionScope.user.roleId == 1}">
                                    <span class="badge bg-danger fs-6 fw-normal px-3 py-2">
                                        <i class="bi bi-shield-check me-1"></i>Quản trị viên
                                    </span>
                                </c:if>
                                <c:if test="${sessionScope.user.roleId == 2}">
                                    <span class="badge fs-6 fw-normal px-3 py-2" style="background-color:#c47c3e">
                                        <i class="bi bi-person-badge me-1"></i>Nhân viên
                                    </span>
                                </c:if>
                            </div>

                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-coffee">
                                    <i class="bi bi-save me-1"></i> Cập nhật thông tin
                                </button>
                                <a href="${pageContext.request.contextPath}/doi-mat-khau"
                                    class="btn btn-outline-coffee">
                                    <i class="bi bi-key me-1"></i> Đổi mật khẩu
                                </a>
                            </div>
                        </form>
                    </div>
                </div>

            </div>
        </div>

        <%@ include file="/views/layout/footer.jsp" %>