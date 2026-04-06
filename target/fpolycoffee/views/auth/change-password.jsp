<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/views/layout/header.jsp" %>

        <div class="flex justify-center py-4">
            <div class="w-full max-w-lg">
                <h1 class="section-title">
                    <span class="material-symbols-outlined text-primary">lock</span>
                    Đổi mật khẩu
                </h1>

                <c:if test="${not empty message}">
                    <div class="alert alert-success">
                        <span class="material-symbols-outlined text-[18px]">check_circle</span> ${message}
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        <span class="material-symbols-outlined text-[18px]">error</span> ${error}
                    </div>
                </c:if>

                <div class="pc-card">
                    <div class="pc-card-header">
                        <span class="material-symbols-outlined text-primary">shield_lock</span>
                        Thay đổi mật khẩu
                    </div>
                    <div class="p-6">
                        <form action="${pageContext.request.contextPath}/doi-mat-khau" method="post">
                            <div class="mb-5">
                                <label class="form-label"><span class="text-error">*</span> Mật khẩu cũ</label>
                                <div class="relative">
                                    <span
                                        class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline text-[18px]">key</span>
                                    <input type="password" class="form-control pl-10" name="oldPassword"
                                        placeholder="Nhập mật khẩu hiện tại" required>
                                </div>
                            </div>
                            <div class="mb-5">
                                <label class="form-label"><span class="text-error">*</span> Mật khẩu mới</label>
                                <div class="relative">
                                    <span
                                        class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline text-[18px]">lock_reset</span>
                                    <input type="password" class="form-control pl-10" name="newPassword"
                                        placeholder="Ít nhất 6 ký tự" required>
                                </div>
                                <p class="text-xs text-on-surface-variant mt-1">Mật khẩu phải có ít nhất 6 ký tự</p>
                            </div>
                            <div class="mb-6">
                                <label class="form-label"><span class="text-error">*</span> Xác nhận mật khẩu
                                    mới</label>
                                <div class="relative">
                                    <span
                                        class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline text-[18px]">lock</span>
                                    <input type="password" class="form-control pl-10" name="confirmPassword"
                                        placeholder="Nhập lại mật khẩu mới" required>
                                </div>
                            </div>
                            <div class="flex gap-3">
                                <button type="submit" class="btn btn-primary flex-1 py-3">
                                    <span class="material-symbols-outlined text-[18px]">check</span> Đổi mật khẩu
                                </button>
                                <a href="${pageContext.request.contextPath}/thong-tin-ca-nhan"
                                    class="btn btn-outline flex-1 py-3">
                                    <span class="material-symbols-outlined text-[18px]">arrow_back</span> Quay lại
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="/views/layout/footer.jsp" %>