<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/views/layout/header.jsp" %>

        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="card shadow-sm border-0 rounded-3">
                    <div class="card-header card-header-mid py-3 border-0">
                        <i class="bi bi-person-plus me-1"></i>
                        ${empty staff ? 'Thêm nhân viên mới' : 'Cập nhật thông tin nhân viên'}
                    </div>
                    <div class="card-body p-4">
                        <form
                            action="${pageContext.request.contextPath}/manager/staff/${empty staff ? 'create' : 'edit'}"
                            method="post">

                            <c:if test="${not empty staff}">
                                <input type="hidden" name="id" value="${staff.id}">
                            </c:if>

                            <div class="mb-3">
                                <label for="fullName" class="form-label fw-semibold">
                                    Họ và tên <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control" id="fullName" name="fullName"
                                    value="${staff.fullName}" placeholder="Nhập họ và tên" required>
                            </div>

                            <div class="mb-3">
                                <label for="email" class="form-label fw-semibold">
                                    Email <span class="text-danger">*</span>
                                </label>
                                <input type="email" class="form-control" id="email" name="email" value="${staff.email}"
                                    placeholder="example@email.com" required>
                            </div>

                            <div class="mb-3">
                                <label for="phone" class="form-label fw-semibold">
                                    Số điện thoại <span class="text-danger">*</span>
                                </label>
                                <input type="tel" class="form-control" id="phone" name="phone" value="${staff.phone}"
                                    placeholder="0xxxxxxxxx" required>
                            </div>

                            <c:if test="${empty staff}">
                                <div class="mb-4">
                                    <label for="password" class="form-label fw-semibold">Mật khẩu</label>
                                    <input type="text" class="form-control" id="password" name="password"
                                        placeholder="Để trống sẽ dùng mật khẩu mặc định: 123456">
                                    <div class="form-text">Mật khẩu mặc định: 123456</div>
                                </div>
                            </c:if>

                            <div class="d-flex justify-content-end gap-2 mt-4">
                                <a href="${pageContext.request.contextPath}/manager/staff"
                                    class="btn btn-outline-secondary">
                                    <i class="bi bi-arrow-left me-1"></i> Quay lại
                                </a>
                                <button type="submit" class="btn btn-coffee">
                                    <i class="bi bi-save me-1"></i> Lưu lại
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>