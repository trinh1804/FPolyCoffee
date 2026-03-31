<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/views/layout/header.jsp" %>

        <div class="row justify-content-center">
            <div class="col-md-5">
                <div class="card shadow">
                    <div class="card-header bg-secondary text-white">
                        <h4 class="mb-0">
                            <i class="bi bi-person"></i> Quên tài khoản
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
                            Vui lòng nhập số điện thoại đã đăng ký để nhận lại thông tin tài khoản.
                        </p>

                        <form action="${pageContext.request.contextPath}/quen-tai-khoan" method="post">
                            <div class="mb-3">
                                <label for="phone" class="form-label">
                                    <i class="bi bi-phone"></i> Số điện thoại
                                </label>
                                <input type="tel" class="form-control" id="phone" name="phone" placeholder="0xxxxxxxxx"
                                    required>
                                <small class="text-muted">Số điện thoại phải bắt đầu bằng 0 và có 10 chữ số</small>
                            </div>

                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-secondary">
                                    <i class="bi bi-search"></i> Tra cứu tài khoản
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