<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/views/layout/header.jsp" %>

        <div class="row justify-content-center">
            <div class="col-sm-10 col-md-6 col-lg-5 col-xl-4">
                <div class="card shadow-sm border-0 rounded-3 overflow-hidden">

                    <!-- Header card -->
                    <div class="card-header text-center py-4 border-0 card-header-coffee">
                        <div class="fs-1 mb-1"><i class="bi bi-cup-hot-fill me-2"></i></div>
                        <h4 class="mb-0 fw-bold">Đăng nhập hệ thống</h4>
                        <small class="opacity-75">FPolyCoffee Management</small>
                    </div>

                    <div class="card-body p-4">
                        <c:if test="${not empty message}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-1"></i> ${message}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/dang-nhap" method="post">
                            <div class="mb-3">
                                <label for="email" class="form-label fw-semibold">
                                    <i class="bi bi-envelope me-1"></i>Email
                                </label>
                                <input type="email" class="form-control" id="email" name="email"
                                    placeholder="example@email.com" required>
                            </div>

                            <div class="mb-3">
                                <label for="password" class="form-label fw-semibold">
                                    <i class="bi bi-lock me-1"></i>Mật khẩu
                                </label>
                                <input type="password" class="form-control" id="password" name="password"
                                    placeholder="Nhập mật khẩu" required>
                            </div>

                            <div class="mb-4 form-check">
                                <input type="checkbox" class="form-check-input" id="remember">
                                <label class="form-check-label" for="remember">Ghi nhớ đăng nhập</label>
                            </div>

                            <div class="d-grid">
                                <button type="submit" class="btn btn-coffee py-2">
                                    <i class="bi bi-box-arrow-in-right me-1"></i> Đăng nhập
                                </button>
                            </div>
                        </form>

                        <hr class="my-3">

                        <div class="d-flex flex-column align-items-center gap-1">
                            <a href="${pageContext.request.contextPath}/quen-mat-khau"
                                class="text-decoration-none small">
                                <i class="bi bi-question-circle me-1"></i>Quên mật khẩu?
                            </a>
                            <a href="${pageContext.request.contextPath}/quen-tai-khoan"
                                class="text-decoration-none small">
                                <i class="bi bi-person me-1"></i>Quên tài khoản?
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="/views/layout/footer.jsp" %>