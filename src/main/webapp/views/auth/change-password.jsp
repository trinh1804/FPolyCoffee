<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/views/layout/header.jsp" %>

<<<<<<< HEAD
        <div class="flex justify-center py-4">
            <div class="w-full max-w-lg">
                <h1 class="section-title">
                    <span class="material-symbols-outlined text-primary">lock</span>
                    Đổi mật khẩu
                </h1>
=======
<div class="flex justify-center py-8">
    <div class="w-full max-w-md">
        <div class="pc-card overflow-hidden">

            <%-- ── Gradient header (đồng nhất với login / forgot pages) ── --%>
            <div class="px-8 pt-8 pb-5" style="background: linear-gradient(135deg, #3d1f0d, #874210);">
                <div class="flex items-center gap-3">
                    <div class="w-10 h-10 rounded-xl bg-white/15 flex items-center justify-center">
                        <span class="material-symbols-outlined text-white text-xl">lock_reset</span>
                    </div>
                    <div>
                        <h2 class="font-headline font-bold text-xl text-white">Đổi mật khẩu</h2>
                        <p class="text-primary-fixed-dim text-xs">Cập nhật mật khẩu đăng nhập của bạn</p>
                    </div>
                </div>
            </div>

            <%-- ── Form body ── --%>
            <div class="p-8">
>>>>>>> origin/Tam

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

<<<<<<< HEAD
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
=======
                <form action="${pageContext.request.contextPath}/doi-mat-khau" method="post"
                      onsubmit="return validatePasswordForm()">

                    <div class="mb-5">
                        <label class="form-label">Mật khẩu hiện tại <span style="color:#C62828">*</span></label>
                        <div class="relative">
                            <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline text-[18px]">key</span>
                            <input type="password" class="form-control pl-10" name="oldPassword"
                                   id="oldPassword" placeholder="Nhập mật khẩu hiện tại"
                                   minlength="1" required>
                        </div>
                    </div>

                    <div class="mb-5">
                        <label class="form-label">Mật khẩu mới <span style="color:#C62828">*</span></label>
                        <div class="relative">
                            <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline text-[18px]">lock_reset</span>
                            <input type="password" class="form-control pl-10" name="newPassword"
                                   id="newPassword" placeholder="Tối thiểu 6 ký tự"
                                   minlength="6" required
                                   oninput="clearConfirmError()">
                        </div>
                        <p class="text-xs mt-1" style="color:#9E7B5E">Mật khẩu phải có ít nhất 6 ký tự</p>
                    </div>

                    <div class="mb-6">
                        <label class="form-label">Xác nhận mật khẩu mới <span style="color:#C62828">*</span></label>
                        <div class="relative">
                            <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline text-[18px]">lock</span>
                            <input type="password" class="form-control pl-10" name="confirmPassword"
                                   id="confirmPassword" placeholder="Nhập lại mật khẩu mới"
                                   minlength="6" required
                                   oninput="clearConfirmError()">
                        </div>
                        <p id="confirmError" class="text-xs mt-1 hidden" style="color:#C62828">
                            <span class="material-symbols-outlined text-[13px]">error</span>
                            Mật khẩu xác nhận không khớp!
                        </p>
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
>>>>>>> origin/Tam
            </div>
        </div>
    </div>
</div>

<script>
function validatePasswordForm() {
    var np  = document.getElementById('newPassword').value;
    var cp  = document.getElementById('confirmPassword').value;
    var err = document.getElementById('confirmError');
    if (np !== cp) {
        err.classList.remove('hidden');
        document.getElementById('confirmPassword').style.borderColor = '#C62828';
        return false;
    }
    return true;
}
function clearConfirmError() {
    var err = document.getElementById('confirmError');
    if (err) err.classList.add('hidden');
    var cf = document.getElementById('confirmPassword');
    if (cf) cf.style.borderColor = '';
}
</script>

<%@ include file="/views/layout/footer.jsp" %>
