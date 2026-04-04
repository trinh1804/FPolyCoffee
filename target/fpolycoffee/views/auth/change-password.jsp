<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/views/layout/header.jsp" %>

        <div class="row justify-content-center">
            <div class="col-md-7 col-lg-5">

                <h4 class="fw-bold mb-4" style="color:#3d1f0d">
                    <i class="bi bi-key me-2"></i>Đổi mật khẩu
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
                    <div class="card-header card-header-gold py-3 border-0">
                        <i class="bi bi-shield-lock me-1"></i> Thay đổi mật khẩu
                    </div>
                    <div class="card-body p-4">
                        <form action="${pageContext.request.contextPath}/doi-mat-khau" method="post">

                            <div class="mb-3">
                                <label for="oldPassword" class="form-label fw-semibold">
                                    <span class="text-danger">*</span> Mật khẩu cũ
                                </label>
                                <input type="password" class="form-control" id="oldPassword" name="oldPassword"
                                    placeholder="Nhập mật khẩu hiện tại" required>
                            </div>

                            <div class="mb-3">
                                <label for="newPassword" class="form-label fw-semibold">
                                    <span class="text-danger">*</span> Mật khẩu mới
                                </label>
                                <input type="password" class="form-control" id="newPassword" name="newPassword"
                                    placeholder="Ít nhất 6 ký tự" required>
                                <div class="form-text">Mật khẩu phải có ít nhất 6 ký tự</div>
                            </div>

                            <div class="mb-4">
                                <label for="confirmPassword" class="form-label fw-semibold">
                                    <span class="text-danger">*</span> Xác nhận mật khẩu mới
                                </label>
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword"
                                    placeholder="Nhập lại mật khẩu mới" required>
                            </div>

                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-coffee">
                                    <i class="bi bi-check-lg me-1"></i> Đổi mật khẩu
                                </button>
                                <a href="${pageContext.request.contextPath}/thong-tin-ca-nhan"
                                    class="btn btn-outline-secondary">
                                    <i class="bi bi-arrow-left me-1"></i> Quay lại
                                </a>
                            </div>
                        </form>
                    </div>
                </div>

            </div>
        </div>

        <%@ include file="/views/layout/footer.jsp" %>