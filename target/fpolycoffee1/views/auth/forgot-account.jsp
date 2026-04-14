<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/views/layout/header.jsp" %>

<div class="flex justify-center py-8">
    <div class="w-full max-w-md">
        <div class="pc-card overflow-hidden">

            <%-- ── Gradient header ── --%>
            <div class="px-8 pt-8 pb-5" style="background: linear-gradient(135deg, #3d1f0d, #874210);">
                <div class="flex items-center gap-3">
                    <div class="w-10 h-10 rounded-xl bg-white/15 flex items-center justify-center">
                        <span class="material-symbols-outlined text-white text-xl">person_search</span>
                    </div>
                    <div>
                        <h2 class="font-headline font-bold text-xl text-white">Quên tài khoản</h2>
                        <p class="text-primary-fixed-dim text-xs">Tra cứu tài khoản theo số điện thoại</p>
                    </div>
                </div>
            </div>

            <%-- ── Form body ── --%>
            <div class="p-8">
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

                <p class="text-sm mb-6 leading-relaxed" style="color:#6B3A1F">
                    Vui lòng nhập số điện thoại đã đăng ký để nhận lại thông tin tài khoản.
                </p>

                <form action="${pageContext.request.contextPath}/quen-tai-khoan" method="post"
                      onsubmit="return validatePhone()">
                    <div class="mb-6">
                        <label class="form-label">Số điện thoại <span style="color:#C62828">*</span></label>
                        <div class="relative">
                            <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline text-[18px]">phone</span>
                            <input type="tel" class="form-control pl-10" name="phone"
                                   id="forgotPhone" placeholder="0xxxxxxxxx"
                                   required maxlength="10"
                                   pattern="0[0-9]{9}"
                                   title="Số điện thoại phải bắt đầu bằng 0 và có đúng 10 chữ số"
                                   oninput="this.value=this.value.replace(/\D/g,'').slice(0,10)">
                        </div>
                        <p class="text-xs mt-1" style="color:#9E7B5E">Bắt đầu bằng 0, đúng 10 chữ số</p>
                    </div>

                    <div class="flex flex-col gap-3">
                        <button type="submit" class="btn btn-primary w-full py-3">
                            <span class="material-symbols-outlined text-[18px]">search</span>
                            Tra cứu tài khoản
                        </button>
                        <a href="${pageContext.request.contextPath}/dang-nhap"
                           class="btn btn-outline w-full py-3">
                            <span class="material-symbols-outlined text-[18px]">arrow_back</span>
                            Quay lại đăng nhập
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
function validatePhone() {
    var v = document.getElementById('forgotPhone').value;
    if (!/^0[0-9]{9}$/.test(v)) {
        alert('Số điện thoại không hợp lệ!\nPhải bắt đầu bằng 0 và có đúng 10 chữ số.');
        return false;
    }
    return true;
}
</script>

<%@ include file="/views/layout/footer.jsp" %>
