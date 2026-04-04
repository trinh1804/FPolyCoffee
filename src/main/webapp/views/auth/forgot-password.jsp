<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/views/layout/header.jsp" %>

        <div class="row justify-content-center">
            <div class="col-sm-10 col-md-6 col-lg-5">
                <div class="card shadow-sm border-0 rounded-3">
                    <div class="card-header card-header-mid py-3 border-0">
                        <i class="bi bi-question-circle me-1"></i> Quên mật khẩu
                    </div>
                    <div class="card-body p-4">
                        <c:if test="${not empty message}">
                            <div class="alert alert-success">
                                <i class="bi bi-check-circle-fill me-1"></i> ${message}
                            </div>
                        </c:if>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">
                                <i class="bi bi-exclamation-triangle-fill me-1"></i> ${error}
                            </div>
                        </c:if>

                        <p class="text-muted small mb-4">
                            Vui lòng nhập email đã đăng ký. Hệ thống sẽ gửi mật khẩu mới đến email của bạn.
                        </p>

                        <form action="${pageContext.request.contextPath}/quen-mat-khau" method="post">
                            <div class="mb-4">
                                <label for="email" class="form-label fw-semibold">
                                    <i class="bi bi-envelope me-1"></i>Email đăng ký
                                </label>
                                <input type="email" class="form-control" id="email" name="email"
                                    placeholder="example@email.com" required>
                            </div>

                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-coffee">
                                    <i class="bi bi-send me-1"></i> Gửi yêu cầu
                                </button>
                                <a href="${pageContext.request.contextPath}/dang-nhap"
                                    class="btn btn-outline-secondary">
                                    <i class="bi bi-arrow-left me-1"></i> Quay lại đăng nhập
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="/views/layout/footer.jsp" %>