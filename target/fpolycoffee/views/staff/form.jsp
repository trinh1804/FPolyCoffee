<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/views/layout/header.jsp" %>

<div class="flex justify-center py-4">
    <div class="w-full max-w-lg">

        <%-- ── Page title (kiểu nhất quán với trang quản lý) ── --%>
        <div class="flex items-center gap-3 mb-6">
            <a href="${pageContext.request.contextPath}/manager/staff" class="btn btn-outline btn-sm">
                <span class="material-symbols-outlined text-[18px]">arrow_back</span>
            </a>
            <h1 class="section-title mb-0">
                <span class="material-symbols-outlined" style="color:#8B4513">
                    ${empty staff ? 'person_add' : 'manage_accounts'}
                </span>
                ${empty staff ? 'Thêm nhân viên mới' : 'Cập nhật nhân viên'}
            </h1>
        </div>

        <%-- ── Flash messages ── --%>
        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-danger mb-4">
                <span class="material-symbols-outlined text-[18px]">error</span> ${sessionScope.error}
                <c:remove var="error" scope="session"/>
            </div>
        </c:if>

        <%-- ── Form card ── --%>
        <div class="pc-card">
            <div class="pc-card-header">
                <span class="material-symbols-outlined" style="color:#8B4513">edit_note</span>
                Thông tin nhân viên
            </div>
            <div class="p-6">
                <form action="${pageContext.request.contextPath}/manager/staff/${empty staff ? 'create' : 'edit'}"
                      method="post"
                      onsubmit="return validateStaffForm()">
                    <c:if test="${not empty staff}">
                        <input type="hidden" name="id" value="${staff.id}">
                    </c:if>

                    <%-- Họ và tên --%>
                    <div class="mb-5">
                        <label class="form-label">Họ và tên <span style="color:#C62828">*</span></label>
                        <div class="relative">
                            <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline text-[18px]">person</span>
                            <input type="text" class="form-control pl-10" name="fullName"
                                   value="${staff.fullName}" placeholder="Nhập họ và tên đầy đủ"
                                   required maxlength="255"
                                   oninput="this.value=this.value.replace(/[0-9]/g,'')">
                        </div>
                        <p class="text-xs mt-1" style="color:#9E7B5E">Chỉ nhập chữ, không nhập số</p>
                    </div>

                    <%-- Email --%>
                    <div class="mb-5">
                        <label class="form-label">Email <span style="color:#C62828">*</span></label>
                        <div class="relative">
                            <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline text-[18px]">mail</span>
                            <input type="email" class="form-control pl-10" name="email"
                                   value="${staff.email}" placeholder="example@email.com"
                                   required maxlength="255">
                        </div>
                    </div>

                    <%-- Số điện thoại --%>
                    <div class="mb-5">
                        <label class="form-label">Số điện thoại <span style="color:#C62828">*</span></label>
                        <div class="relative">
                            <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline text-[18px]">phone</span>
                            <input type="tel" class="form-control pl-10" name="phone"
                                   value="${staff.phone}" placeholder="0xxxxxxxxx"
                                   required maxlength="10"
                                   pattern="0[0-9]{9}"
                                   title="Số điện thoại phải bắt đầu bằng 0 và có đúng 10 chữ số"
                                   oninput="this.value=this.value.replace(/\D/g,'').slice(0,10)">
                        </div>
                        <p class="text-xs mt-1" style="color:#9E7B5E">Bắt đầu bằng 0, đúng 10 chữ số</p>
                    </div>

                    <%-- Mật khẩu (chỉ khi thêm mới) --%>
                    <c:if test="${empty staff}">
                        <div class="mb-6">
                            <label class="form-label">Mật khẩu</label>
                            <div class="relative">
                                <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline text-[18px]">lock</span>
                                <input type="text" class="form-control pl-10" name="password"
                                       id="staffPassword"
                                       placeholder="Để trống để dùng mật khẩu mặc định: 123456"
                                       minlength="6" maxlength="255">
                            </div>
                            <p class="text-xs mt-1" style="color:#9E7B5E">
                                Mật khẩu mặc định: <strong>123456</strong>. Nếu nhập phải từ 6 ký tự trở lên.
                            </p>
                        </div>
                    </c:if>

                    <%-- Buttons --%>
                    <div class="flex gap-3 pt-2">
                        <button type="submit" class="btn btn-primary flex-1 py-3">
                            <span class="material-symbols-outlined text-[18px]">save</span>
                            ${empty staff ? 'Thêm nhân viên' : 'Lưu thay đổi'}
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

<script>
function validateStaffForm() {
    var phone = document.querySelector('input[name="phone"]').value;
    if (!/^0[0-9]{9}$/.test(phone)) {
        alert('Số điện thoại không hợp lệ!\nPhải bắt đầu bằng 0 và có đúng 10 chữ số.');
        return false;
    }
    var pwdEl = document.getElementById('staffPassword');
    if (pwdEl && pwdEl.value.length > 0 && pwdEl.value.length < 6) {
        alert('Mật khẩu phải có ít nhất 6 ký tự!');
        return false;
    }
    return true;
}
</script>

<%@ include file="/views/layout/footer.jsp" %>
