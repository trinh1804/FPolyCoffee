<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/views/layout/header.jsp" %>

        <div class="flex justify-center py-4">
            <div class="w-full max-w-lg">
                <h1 class="section-title">
                    <span class="material-symbols-outlined text-primary">account_circle</span>
                    Thông tin cá nhân
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
                        <span class="material-symbols-outlined text-primary">edit_note</span>
                        Cập nhật thông tin
                    </div>
                    <div class="p-6">
                        <form action="${pageContext.request.contextPath}/thong-tin-ca-nhan" method="post">
                            <div class="mb-5">
                                <label class="form-label"><span class="text-error">*</span> Họ và tên</label>
                                <div class="relative">
                                    <span
                                        class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline text-[18px]">person</span>
                                    <input type="text" class="form-control pl-10" name="fullName"
                                        value="${sessionScope.user.fullName}" required>
                                </div>
                                <c:if test="${not empty fullNameError}">
                                    <p class="text-xs text-error mt-1">${fullNameError}</p>
                                </c:if>
                            </div>
                            <div class="mb-5">
                                <label class="form-label">Email</label>
                                <div class="relative">
                                    <span
                                        class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline text-[18px]">mail</span>
                                    <input type="email" class="form-control pl-10 opacity-60 cursor-not-allowed"
                                        value="${sessionScope.user.email}" readonly disabled>
                                </div>
                                <p class="text-xs text-on-surface-variant mt-1">Email không thể thay đổi</p>
                            </div>
                            <div class="mb-5">
                                <label class="form-label"><span class="text-error">*</span> Số điện thoại</label>
                                <div class="relative">
                                    <span
                                        class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline text-[18px]">phone</span>
                                    <input type="tel" class="form-control pl-10" name="phone"
<<<<<<< HEAD
                                        value="${sessionScope.user.phone}" placeholder="0xxxxxxxxx" required>
=======
                                        value="${sessionScope.user.phone}" placeholder="0xxxxxxxxx" required
                                        maxlength="10" pattern="0[0-9]{9}"
                                        title="Số điện thoại phải bắt đầu bằng 0 và có đúng 10 chữ số"
                                        oninput="this.value=this.value.replace(/\D/g,'').slice(0,10)">
>>>>>>> origin/Tam
                                </div>
                                <c:if test="${not empty phoneError}">
                                    <p class="text-xs text-error mt-1">${phoneError}</p>
                                </c:if>
                            </div>
                            <div class="mb-6">
                                <label class="form-label">Vai trò</label>
                                <div>
                                    <c:if test="${sessionScope.user.roleId == 1}">
                                        <span class="badge badge-danger py-1.5 px-4 text-sm">
                                            <span class="material-symbols-outlined text-[16px]">shield</span> Quản trị
                                            viên
                                        </span>
                                    </c:if>
                                    <c:if test="${sessionScope.user.roleId == 2}">
                                        <span class="badge badge-gold py-1.5 px-4 text-sm">
                                            <span class="material-symbols-outlined text-[16px]">badge</span> Nhân viên
                                        </span>
                                    </c:if>
                                </div>
                            </div>
                            <div class="flex flex-col gap-3">
                                <button type="submit" class="btn btn-primary py-3">
                                    <span class="material-symbols-outlined text-[18px]">save</span> Cập nhật thông tin
                                </button>
                                <a href="${pageContext.request.contextPath}/doi-mat-khau" class="btn btn-outline py-3">
                                    <span class="material-symbols-outlined text-[18px]">lock</span> Đổi mật khẩu
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="/views/layout/footer.jsp" %>