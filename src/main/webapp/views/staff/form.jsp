<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ include file="/views/layout/header.jsp" %>

            <div class="flex justify-center py-4">
                <div class="w-full max-w-lg">
                    <div class="flex items-center gap-3 mb-6">
                        <a href="${pageContext.request.contextPath}/manager/staff" class="btn btn-outline btn-sm">
                            <span class="material-symbols-outlined text-[18px]">arrow_back</span>
                        </a>
                        <h1 class="section-title mb-0">
                            <span class="material-symbols-outlined text-primary">person_add</span>
                            ${empty staff ? 'Thêm nhân viên mới' : 'Cập nhật nhân viên'}
                        </h1>
                    </div>

                    <div class="pc-card">
                        <div class="pc-card-header">
                            <span class="material-symbols-outlined text-primary">edit</span>
                            ${empty staff ? 'Thông tin nhân viên mới' : 'Chỉnh sửa thông tin'}
                        </div>
                        <div class="p-6">
                            <form
                                action="${pageContext.request.contextPath}/manager/staff/${empty staff ? 'create' : 'edit'}"
                                method="post">
                                <c:if test="${not empty staff}">
                                    <input type="hidden" name="id" value="${staff.id}">
                                </c:if>

                                <div class="mb-5">
                                    <label class="form-label">Họ và tên <span class="text-error">*</span></label>
                                    <div class="relative">
                                        <span
                                            class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline text-[18px]">person</span>
                                        <input type="text" class="form-control pl-10" name="fullName"
                                            value="${staff.fullName}" placeholder="Nhập họ và tên" required>
                                    </div>
                                </div>

                                <div class="mb-5">
                                    <label class="form-label">Email <span class="text-error">*</span></label>
                                    <div class="relative">
                                        <span
                                            class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline text-[18px]">mail</span>
                                        <input type="email" class="form-control pl-10" name="email"
                                            value="${staff.email}" placeholder="example@email.com" required>
                                    </div>
                                </div>

                                <div class="mb-5">
                                    <label class="form-label">Số điện thoại <span class="text-error">*</span></label>
                                    <div class="relative">
                                        <span
                                            class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline text-[18px]">phone</span>
                                        <input type="tel" class="form-control pl-10" name="phone" value="${staff.phone}"
                                            placeholder="0xxxxxxxxx" required>
                                    </div>
                                </div>

                                <c:if test="${empty staff}">
                                    <div class="mb-6">
                                        <label class="form-label">Mật khẩu</label>
                                        <div class="relative">
                                            <span
                                                class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline text-[18px]">lock</span>
                                            <input type="text" class="form-control pl-10" name="password"
                                                placeholder="Để trống dùng mật khẩu mặc định: 123456">
                                        </div>
                                        <p class="text-xs text-on-surface-variant mt-1">Mật khẩu mặc định:
                                            <strong>123456</strong>
                                        </p>
                                    </div>
                                </c:if>

                                <div class="flex gap-3 mt-6">
                                    <button type="submit" class="btn btn-primary flex-1 py-3">
                                        <span class="material-symbols-outlined text-[18px]">save</span> Lưu lại
                                    </button>
                                    <a href="${pageContext.request.contextPath}/manager/staff"
                                        class="btn btn-outline flex-1 py-3">
                                        <span class="material-symbols-outlined text-[18px]">close</span> Hủy
                                    </a>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <%@ include file="/views/layout/footer.jsp" %>