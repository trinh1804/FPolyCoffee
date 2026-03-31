<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/views/layout/header.jsp" %>

        <h2 class="mb-4">
            <i class="bi bi-key"></i> Đổi mật khẩu
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
                    <div class="card-header bg-warning">
                        <h5 class="mb-0">
                            <i class="bi bi-shield-lock"></i> Thay đổi mật khẩu
                        </h5>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/doi-mat-khau" method="post">
                            <div class="mb-3">
                                <label for="oldPassword" class="form-label">
                                    <span class="text-danger">*</span> Mật khẩu cũ
                                </label>
                                <input type="password" class="form-control" id="oldPassword" name="oldPassword"
                                    placeholder="Nhập mật khẩu hiện tại" required>
                            </div>

                            <div class="mb-3">
                                <label for="newPassword" class="form-label">
                                    <span class="text-danger">*</span> Mật khẩu mới
                                </label>
                                <input type="password" class="form-control" id="newPassword" name="newPassword"
                                    placeholder="Nhập mật khẩu mới (ít nhất 6 ký tự)" required>
                                <small class="text-muted">Mật khẩu phải có ít nhất 6 ký tự</small>
                            </div>

                            <div class="mb-3">
                                <label for="confirmPassword" class="form-label">
                                    <span class="text-danger">*</span> Xác nhận mật khẩu mới
                                </label>
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword"
                                    placeholder="Nhập lại mật khẩu mới" required>
                            </div>

                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-warning">
                                    <i class="bi bi-check-lg"></i> Đổi mật khẩu
                                </button>
                                <a href="${pageContext.request.contextPath}/thong-tin-ca-nhan"
                                    class="btn btn-secondary">
                                    <i class="bi bi-arrow-left"></i> Quay lại
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="/views/layout/footer.jsp" %>