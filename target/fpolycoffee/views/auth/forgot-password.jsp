<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/views/layout/header.jsp" %>

        <div class="row justify-content-center">
            <div class="col-md-5">
                <div class="card shadow">
                    <div class="card-header bg-info text-white">
                        <h4 class="mb-0">
                            <i class="bi bi-question-circle"></i> Quên mật khẩu
                        </h4>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty message}">
                            <div class="alert alert-success">
                                <i class="bi bi-check-circle-fill"></i> ${message}
                            </div>
                        </c:if>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">
                                <i class="bi bi-exclamation-triangle-fill"></i> ${error}
                            </div>
                        </c:if>

                        <p class="text-muted">
                            Vui lòng nhập email đã đăng ký. Hệ thống sẽ gửi mật khẩu mới đến email của bạn.
                        </p>

                        <form action="${pageContext.request.contextPath}/quen-mat-khau" method="post">
                            <div class="mb-3">
                                <label for="email" class="form-label">
                                    <i class="bi bi-envelope"></i> Email đăng ký
                                </label>
                                <input type="email" class="form-control" id="email" name="email"
                                    placeholder="example@email.com" required>
                            </div>

                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-info">
                                    <i class="bi bi-send"></i> Gửi yêu cầu
                                </button>
                                <a href="${pageContext.request.contextPath}/dang-nhap" class="btn btn-secondary">
                                    <i class="bi bi-arrow-left"></i> Quay lại đăng nhập
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="/views/layout/footer.jsp" %>